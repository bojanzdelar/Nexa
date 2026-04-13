import { getQuery } from "h3";
import {
  S3Client,
  PutObjectCommand,
  HeadObjectCommand,
} from "@aws-sdk/client-s3";
import crypto from "crypto";

const enabled = process.env.SNAPSHOT_ENABLED === "true";

const bucket = process.env.SNAPSHOT_BUCKET;

const s3 = enabled
  ? new S3Client({ region: process.env.AWS_REGION || "eu-central-1" })
  : null;

const SNAPSHOT_ROUTES = [
  /^\/$/,
  /^\/movies(\/.*)?$/,
  /^\/shows(\/.*)?$/,
  /^\/latest$/,
];

function isSnapshotRoute(path: string) {
  return SNAPSHOT_ROUTES.some((regex) => regex.test(path));
}

function hash(content: string) {
  return crypto.createHash("sha256").update(content).digest("hex");
}

async function getExistingHash(key: string) {
  try {
    const res = await s3!.send(
      new HeadObjectCommand({
        Bucket: bucket,
        Key: key,
      }),
    );

    return res.Metadata?.hash || null;
  } catch {
    return null;
  }
}

export default defineNitroPlugin((nitroApp) => {
  if (!enabled || !bucket) return;

  nitroApp.hooks.hook("render:html", async (html, { event }) => {
    const path = event.path;
    const query = getQuery(event);

    if (!isSnapshotRoute(path)) return;
    if (event.node.req.headers.authorization) return;
    if (query.s && Number(query.s) !== 1) return;

    html.bodyAppend.push(`<script>window.__SNAPSHOT__=true</script>`);

    const fullHtml = `<!DOCTYPE html>
    <html${html.htmlAttrs.join("")}>
    ${html.head.join("")}
    ${html.body.join("")}
    ${html.bodyAppend.join("")}
    </html>`;

    const key =
      path === "/" ? "index.html" : path.replace(/^\/+/, "") + ".html";

    const contentHash = hash(fullHtml);

    try {
      const existingHash = await getExistingHash(key);

      if (existingHash === contentHash) {
        console.log("Skip (unchanged):", key);
        return;
      }

      await s3!.send(
        new PutObjectCommand({
          Bucket: bucket,
          Key: key,
          Body: fullHtml,
          ContentType: "text/html",
          CacheControl: "public, max-age=86400, stale-while-revalidate=600",
          Metadata: {
            hash: contentHash,
          },
        }),
      );

      console.log("Snapshot saved:", key);
    } catch (e) {
      console.error("Snapshot failed:", key, e);
    }
  });
});

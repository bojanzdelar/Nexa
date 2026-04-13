function handler(event) {
  const request = event.request;
  const host = request.headers.host.value;

  const allowed = ["${domain_name}", "www.${domain_name}"];

  if (!allowed.includes(host)) {
    return {
      statusCode: 403,
      statusDescription: "Forbidden",
    };
  }

  return request;
}

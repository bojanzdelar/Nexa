exports.handler = async (event) => {
  const request = event.Records[0].cf.request;
  const uri = request.uri;

  if (request.origin && request.origin.s3) {
    if (uri === "/") {
      request.uri = "/index.html";
      return request;
    }

    request.uri = uri + ".html";
  }

  return request;
};

enum StatusCode {
  Success,
  InvalidEmailOrPassword,
  Empty,
  Failed,
  ResponseSuccess
  // Add other status codes as needed...
}

// Then, you can define a function that maps these enum values to the corresponding numbers:
int getStatusCodeValue(StatusCode code) {
  switch (code) {
    case StatusCode.Success:
      return 101;
    case StatusCode.InvalidEmailOrPassword:
      return 106;
    case StatusCode.Empty:
      return 102;
    case StatusCode.Failed:
      return 104;
    case StatusCode.ResponseSuccess:
      return 200;
    default:
      return 0;
  }
}

resource "aws_cloudwatch_log_group" "triangle_classification_api_logs" {
  name = "triangle-classification-api-logs"
  retention_in_days = 14
  tags = {
    Application = "Triangle Classification"
  }
}

resource "aws_cloudwatch_log_stream" "triangle_classification_errors" {
  name           = "errors"
  log_group_name = aws_cloudwatch_log_group.triangle_classification_api_logs.name
}

resource "aws_cloudwatch_log_stream" "triangle_classification_succeededs" {
  name           = "succeededs"
  log_group_name = aws_cloudwatch_log_group.triangle_classification_api_logs.name
}

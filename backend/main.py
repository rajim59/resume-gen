import functions_framework

@functions_framework.http
def parse_pdf(request):
    return "Backend is running!"
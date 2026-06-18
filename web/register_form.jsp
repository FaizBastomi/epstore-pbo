<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="id">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Register - EpStore</title>

        <!-- Google Fonts (Plus Jakarta Sans) -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">

        <!-- Bootstrap 5 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

        <style>
            body {
                font-family: 'Plus Jakarta Sans', sans-serif;
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0;
                padding: 20px;
            }
        </style>
    </head>

    <body class="bg-light">

        <div class="card shadow-sm border-0" style="max-width: 400px; width: 100%; border-radius: 12px;">
            <div class="card-header bg-primary text-white text-center py-3"
                 style="border-top-left-radius: 12px; border-top-right-radius: 12px;">
                <h4 class="m-0 fw-bold">EpStore</h4>
            </div>
            <div class="card-body p-4">
                <!-- Success & Error Messages -->
                <% if (request.getAttribute("error") != null) {%>
                <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <div>
                        <%= request.getAttribute("error")%>
                    </div>
                </div>
                <% } %>

                <% if (request.getAttribute("success") != null) {%>
                <div class="alert alert-success d-flex align-items-center gap-2 mb-3" role="alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <div>
                        <%= request.getAttribute("success")%>
                    </div>
                </div>
                <% }%>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/auth" method="POST" autocomplete="on">
                    <!-- Hidden Parameter to trigger registration in AuthController -->
                    <input type="hidden" name="register" value="true">

                    <!-- Email -->
                    <div class="mb-3">
                        <label for="email" class="form-label text-secondary small fw-bold">Email</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                            <input type="email" class="form-control" id="email" name="email" placeholder="Email" required>
                        </div>
                    </div>

                    <!-- Username -->
                    <div class="mb-3">
                        <label for="username" class="form-label text-secondary small fw-bold">Username</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                        </div>
                    </div>

                    <!-- Password -->
                    <div class="mb-4">
                        <label for="password" class="form-label text-secondary small fw-bold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                            <button class="btn btn-outline-secondary" type="button" id="togglePasswordBtn" aria-label="Toggle password visibility">
                                <i class="bi bi-eye" id="togglePasswordIcon"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mb-3">Daftar</button>
                </form>

                <!-- Footer Links -->
                <div class="text-center small text-muted">
                    Sudah punya akun?
                    <a href="${pageContext.request.contextPath}/auth?login" class="text-primary text-decoration-none fw-bold">Login di sini</a>
                </div>

            </div>
        </div>

        <!-- Bootstrap Bundle JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Toggle Password Script -->
        <script>
            const passwordInput = document.getElementById('password');
            const togglePasswordBtn = document.getElementById('togglePasswordBtn');
            const togglePasswordIcon = document.getElementById('togglePasswordIcon');

            togglePasswordBtn.addEventListener('click', function () {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);

                // Toggle icons
                if (type === 'password') {
                    togglePasswordIcon.classList.remove('bi-eye-slash');
                    togglePasswordIcon.classList.add('bi-eye');
                } else {
                    togglePasswordIcon.classList.remove('bi-eye');
                    togglePasswordIcon.classList.add('bi-eye-slash');
                }
            });

            // Sanitize username input: remove spaces and convert to lowercase
            const usernameInput = document.getElementById('username');
            if (usernameInput) {
                usernameInput.addEventListener('input', function () {
                    this.value = this.value.replace(/\s+/g, '').toLowerCase();
                });
            }
        </script>
    </body>

</html>
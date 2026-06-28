<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/header.jsp" %>

<style>
  .login-page {
    min-height: 100vh;
    background: linear-gradient(135deg, #e8f5f0 0%, #dceefb 50%, #f0f7ee 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 80px 1rem 2rem;
    position: relative;
    overflow: hidden;
  }

  .login-page::before {
    content: '';
    position: absolute;
    width: 400px;
    height: 400px;
    background: rgba(29, 158, 117, 0.12);
    border-radius: 50%;
    top: -120px;
    left: -100px;
    filter: blur(80px);
    pointer-events: none;
  }

  .login-page::after {
    content: '';
    position: absolute;
    width: 350px;
    height: 350px;
    background: rgba(55, 138, 221, 0.10);
    border-radius: 50%;
    bottom: -100px;
    right: -80px;
    filter: blur(70px);
    pointer-events: none;
  }

  .login-card {
    background: #ffffff;
    border: 2px solid #1d9e75;
    border-radius: 20px;
    padding: 2.5rem 2.5rem 2rem;
    width: 100%;
    max-width: 420px;
    position: relative;
    z-index: 1;
    box-shadow: 0 0 0 6px rgba(29, 158, 117, 0.10), 0 12px 48px rgba(29, 158, 117, 0.13);
  }

  .login-card-badge {
    position: absolute;
    top: -15px;
    left: 50%;
    transform: translateX(-50%);
    background: #1d9e75;
    color: #ffffff;
    font-size: 12px;
    font-weight: 600;
    padding: 4px 20px;
    border-radius: 20px;
    letter-spacing: 0.5px;
    white-space: nowrap;
  }

  .login-card h1 {
    font-size: 26px;
    font-weight: 700;
    color: #0f3d2e;
    margin: 0.5rem 0 4px;
    text-align: center;
  }

  .login-card .muted {
    font-size: 13px;
    color: #5a8a78;
    text-align: center;
    margin: 0 0 1.75rem;
    line-height: 1.5;
  }

  .login-card label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: #2d5a4a;
    margin-bottom: 5px;
  }

  .login-card input[type="email"],
  .login-card input[type="password"],
  .login-card input[type="text"] {
    width: 100%;
    background: #f4faf7;
    border: 1.5px solid #9fd6c3;
    border-radius: 10px;
    color: #1a3a2e;
    font-size: 14px;
    padding: 10px 14px;
    margin-bottom: 1.1rem;
    outline: none;
    box-sizing: border-box;
    transition: border-color 0.2s, box-shadow 0.2s;
    display: block;
  }

  .login-card input[type="email"]::placeholder,
  .login-card input[type="password"]::placeholder,
  .login-card input[type="text"]::placeholder {
    color: #a0bfb5;
  }

  .login-card input[type="email"]:focus,
  .login-card input[type="password"]:focus,
  .login-card input[type="text"]:focus {
    border-color: #1d9e75;
    box-shadow: 0 0 0 3px rgba(29, 158, 117, 0.13);
  }

  .login-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1.4rem;
    font-size: 12px;
  }

  .login-options label {
    display: flex;
    align-items: center;
    gap: 6px;
    color: #5a7a6e;
    font-weight: 400;
    margin: 0;
    cursor: pointer;
  }

  .login-options input[type="checkbox"] {
    accent-color: #1d9e75;
    margin: 0;
  }

  .login-options a {
    color: #1d9e75;
    font-size: 12px;
    text-decoration: none;
  }

  .login-options a:hover { text-decoration: underline; }

  .btn-login {
    width: 100%;
    background: #1d9e75;
    border: none;
    color: #ffffff;
    font-size: 15px;
    font-weight: 600;
    padding: 12px;
    border-radius: 10px;
    cursor: pointer;
    margin-bottom: 1.1rem;
    transition: background 0.2s, transform 0.1s;
    letter-spacing: 0.3px;
  }

  .btn-login:hover { background: #0f6e56; }
  .btn-login:active { transform: scale(0.98); }

  .login-divider {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 1.1rem;
    color: #8aada3;
    font-size: 12px;
  }

  .login-divider::before,
  .login-divider::after {
    content: '';
    flex: 1;
    height: 1px;
    background: #c8e6dc;
  }

  .btn-google {
    width: 100%;
    background: #ffffff;
    border: 1.5px solid #c8e6dc;
    color: #2d5a4a;
    font-size: 14px;
    font-weight: 500;
    padding: 11px;
    border-radius: 10px;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    margin-bottom: 1.4rem;
    transition: background 0.2s, border-color 0.2s;
    box-sizing: border-box;
    text-decoration: none;
  }

  .btn-google:hover {
    background: #f4faf7;
    border-color: #1d9e75;
  }

  .login-footer {
    text-align: center;
    font-size: 13px;
    color: #7a9d92;
    margin: 0;
  }

  .login-footer a {
    color: #f97316;
    font-weight: 600;
    text-decoration: none;
  }

  .login-footer a:hover { text-decoration: underline; }
</style>

<section class="login-page">
  <div class="login-card">

    <div class="login-card-badge">&#10022; Member Login</div>

    <h1>Welcome Back!</h1>
    <p class="muted">Sign in to access your wishlist, contact sellers, or manage listings.</p>

    <%-- autocomplete="off" on form disables browser autofill --%>
    <form action="<%=ctx%>/login" method="post" autocomplete="off" data-validate>

      <%-- Hidden dummy fields trick browsers that ignore autocomplete="off" --%>
      <input type="text"     style="display:none" name="fake_email"    />
      <input type="password" style="display:none" name="fake_password" />

      <label>&#9993; Email</label>
      <input type="text"
             name="email"
             placeholder="you@example.com"
             autocomplete="off"
             required />

      <label>&#128274; Password</label>
      <input type="password"
             name="password"
             placeholder="••••••••"
             autocomplete="new-password"
             required />

      <div class="login-options">
        <label>
          <input type="checkbox" name="remember" /> Remember me
        </label>
        <a href="#">Forgot password?</a>
      </div>

      <button class="btn-login" type="submit">Login</button>

    </form>

    <div class="login-divider">or continue with</div>

    <a class="btn-google" href="#">
      <svg width="18" height="18" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
        <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
        <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
        <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
      </svg>
      Sign in with Google
    </a>

    <p class="login-footer">
      New to AutoMart? <a href="<%=ctx%>/register.jsp">Create an account</a>
    </p>

  </div>
</section>
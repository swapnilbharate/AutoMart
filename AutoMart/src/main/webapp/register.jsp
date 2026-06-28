<%@ include file="/WEB-INF/header.jsp" %>

<style>
  .register-page {
    min-height: 100vh;
    background: linear-gradient(135deg, #e8f5f0 0%, #dceefb 50%, #f0f7ee 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 80px 1rem 2rem;
    position: relative;
    overflow: hidden;
  }

  .register-page::before {
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

  .register-page::after {
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

  .register-card {
    background: #ffffff;
    border: 2px solid #1d9e75;
    border-radius: 20px;
    padding: 2.5rem 2.5rem 2rem;
    width: 100%;
    max-width: 460px;
    position: relative;
    z-index: 1;
    box-shadow: 0 0 0 6px rgba(29, 158, 117, 0.10),
                0 12px 48px rgba(29, 158, 117, 0.13);
  }

  .register-card-badge {
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

  .register-card h1 {
    font-size: 26px;
    font-weight: 700;
    color: #0f3d2e;
    margin: 0.5rem 0 4px;
    text-align: center;
  }

  .register-card .muted {
    font-size: 13px;
    color: #5a8a78;
    text-align: center;
    margin: 0 0 1.75rem;
    line-height: 1.5;
  }

  .form-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 1rem;
  }

  .form-full {
    grid-column: 1 / -1;
  }

  .register-card label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    color: #2d5a4a;
    margin-bottom: 5px;
  }

  .register-card input[type="text"],
  .register-card input[type="email"],
  .register-card input[type="password"],
  .register-card input[type="tel"],
  .register-card input,
  .register-card select {
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
    appearance: none;
    -webkit-appearance: none;
    font-family: inherit;
  }

  .register-card input::placeholder {
    color: #a0bfb5;
  }

  .register-card input:focus,
  .register-card select:focus {
    border-color: #1d9e75;
    box-shadow: 0 0 0 3px rgba(29, 158, 117, 0.13);
  }

  .select-wrapper {
    position: relative;
    margin-bottom: 1.1rem;
  }

  .select-wrapper select {
    margin-bottom: 0;
    padding-right: 36px;
    cursor: pointer;
  }

  .select-wrapper::after {
    content: '';
    position: absolute;
    right: 14px;
    top: 50%;
    transform: translateY(-50%);
    width: 0;
    height: 0;
    border-left: 5px solid transparent;
    border-right: 5px solid transparent;
    border-top: 6px solid #1d9e75;
    pointer-events: none;
  }

  .btn-register {
    width: 100%;
    background: #1d9e75;
    border: none;
    color: #ffffff;
    font-size: 15px;
    font-weight: 600;
    padding: 12px;
    border-radius: 10px;
    cursor: pointer;
    margin-top: 0.4rem;
    margin-bottom: 1.1rem;
    transition: background 0.2s, transform 0.1s;
    letter-spacing: 0.3px;
  }

  .btn-register:hover { background: #0f6e56; }
  .btn-register:active { transform: scale(0.98); }

  .register-footer {
    text-align: center;
    font-size: 13px;
    color: #7a9d92;
    margin: 0;
  }

  .register-footer a {
    color: #f97316;
    font-weight: 600;
    text-decoration: none;
  }

  .register-footer a:hover { text-decoration: underline; }

  .field-label {
    font-size: 13px;
    font-weight: 600;
    color: #2d5a4a;
    display: block;
    margin-bottom: 5px;
  }
</style>

<section class="register-page">
  <div class="register-card">

    <div class="register-card-badge">&#10022; Join AutoMart</div>

    <h1>Create Account</h1>
    <p class="muted">Join thousands of buyers and sellers on AutoMart.</p>

    <%-- autocomplete="off" stops browser from filling any field automatically --%>
    <form action="<%=ctx%>/register" method="post" autocomplete="off">

      <%-- Hidden fake fields trick: browsers target the first text+password fields.
           These invisible decoys absorb the autofill so real fields stay empty. --%>
      <input type="text"     style="display:none" aria-hidden="true" tabindex="-1">
      <input type="password" style="display:none" aria-hidden="true" tabindex="-1">

      <div class="form-grid">

        <!-- Name -->
        <div>
          <span class="field-label">&#128100; Name</span>
          <input type="text"
                 name="name"
                 placeholder="Full name"
                 autocomplete="off"
                 required />
        </div>

        <!-- Phone -->
        <div>
          <span class="field-label">&#128222; Phone</span>
          <input type="text"
                 name="phone"
                 placeholder="Mobile number"
                 autocomplete="off"
                 required />
        </div>

        <!-- Email -->
        <div class="form-full">
          <span class="field-label">&#9993; Email</span>
          <input type="email"
                 name="email"
                 placeholder="you@example.com"
                 autocomplete="off"
                 required />
        </div>

        <!-- Password -->
        <div>
          <span class="field-label">&#128274; Password</span>
          <input type="password"
                 name="password"
                 placeholder="&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;&#9679;"
                 autocomplete="new-password"
                 required />
        </div>

        <!-- City -->
        <div>
          <span class="field-label">&#127968; City</span>
          <input type="text"
                 name="city"
                 placeholder="Your city"
                 autocomplete="off"
                 required />
        </div>

        <!-- Role -->
        <div class="form-full">
          <span class="field-label">&#127775; Role</span>
          <div class="select-wrapper">
            <select name="role" autocomplete="off">
              <option value="USER">Normal User</option>
              <option value="ADMIN">Admin</option>
            </select>
          </div>
        </div>

      </div>

      <button class="btn-register" type="submit">Create Account</button>

    </form>

    <p class="register-footer">
      Already have an account? <a href="<%=ctx%>/login.jsp">Login here</a>
    </p>

  </div>
</section>

<%-- Extra JS safety net: clears any autofilled values on page load --%>
<script>
  window.addEventListener('load', function () {
    // Small delay lets the browser finish autofilling, then we wipe it
    setTimeout(function () {
      var fields = document.querySelectorAll(
        '.register-card input[type="text"], ' +
        '.register-card input[type="email"], ' +
        '.register-card input[type="password"], ' +
        '.register-card input[type="tel"]'
      );
      fields.forEach(function (f) {
        // Only clear if the field wasn't typed in by the user
        if (!f.dataset.userTyped) {
          f.value = '';
        }
      });
    }, 100);

    // Mark as user-typed once they actually type
    document.querySelectorAll('.register-card input').forEach(function (f) {
      f.addEventListener('input', function () {
        f.dataset.userTyped = 'true';
      });
    });
  });
</script>


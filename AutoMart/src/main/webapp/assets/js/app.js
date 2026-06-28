document.addEventListener("DOMContentLoaded", function () {
  const toggle = document.querySelector("[data-nav-toggle]");
  const nav = document.querySelector("[data-nav]");
  if (toggle && nav) {
    toggle.addEventListener("click", () => nav.classList.toggle("open"));
  }

  document.querySelectorAll("form[data-validate]").forEach((form) => {
    form.addEventListener("submit", (event) => {
      const required = form.querySelectorAll("[required]");
      let valid = true;
      required.forEach((field) => {
        if (!field.value.trim()) {
          valid = false;
          field.classList.add("invalid");
        } else {
          field.classList.remove("invalid");
        }
      });
      const email = form.querySelector("input[type='email']");
      if (email && email.value && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
        valid = false;
        email.classList.add("invalid");
      }
      const password = form.querySelector("input[name='password']");
      if (password && password.value.length < 6) {
        valid = false;
        password.classList.add("invalid");
      }
      if (!valid) {
        event.preventDefault();
        alert("Please complete all required fields correctly.");
      }
    });
  });
});

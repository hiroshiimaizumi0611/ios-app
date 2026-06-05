const form = document.querySelector(".notify-form");
const emailInput = document.querySelector("#email");
const message = document.querySelector(".form-message");

function isValidEmail(value) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
}

if (form && emailInput && message) {
  form.addEventListener("submit", (event) => {
    event.preventDefault();

    const email = emailInput.value.trim();

    if (!isValidEmail(email)) {
      message.textContent = "メールアドレスを確認してください。";
      message.dataset.state = "error";
      emailInput.focus();
      return;
    }

    try {
      window.localStorage?.setItem("yasumidokiWaitlistPreviewEmail", email);
    } catch {
      // Preview still works when browser storage is unavailable.
    }
    message.textContent = "ありがとうございます。公開時にお知らせできるよう準備します。";
    message.dataset.state = "success";
    form.dataset.submitted = "true";
  });
}

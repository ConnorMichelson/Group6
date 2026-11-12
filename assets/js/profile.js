const profileForm = document.getElementById("profile-form");
const profileStatus = document.getElementById("profile-status");
const addressFields = {
  addressLine: document.getElementById("profile-address-line"),
  city: document.getElementById("profile-city"),
  state: document.getElementById("profile-state"),
  zip: document.getElementById("profile-zip"),
};
const profileFields = {
  firstName: document.getElementById("profile-first-name"),
  lastName: document.getElementById("profile-last-name"),
  email: document.getElementById("profile-email"),
  ...addressFields,
};

function validateAddress() {
  const inputs = Object.values(addressFields);
  const hasAddress = inputs.some((input) => input.value.trim());
  let firstInvalid = null;
  for (const input of inputs) {
    const value = input.value.trim();
    let message = "";
    if (hasAddress && !value) {
      message = "Cannot be null.";
    } else if (
      input === addressFields.zip &&
      value &&
      !/^[0-9]{5}$/.test(input.value)
    ) {
      message = "ZIP code must be exactly five digits.";
    }
    document.getElementById(input.id + "-error").textContent = message;
    input.setAttribute("aria-invalid", String(Boolean(message)));
    if (message && !firstInvalid) firstInvalid = input;
  }
  return firstInvalid;
}

for (const input of Object.values(addressFields)) {
  input.addEventListener("blur", validateAddress);
}
addressFields.state.addEventListener("change", validateAddress);

function showProfileStatus(message, isError = false) {
  profileStatus.classList.toggle("text-danger", isError);
  profileStatus.textContent = message;
}

async function requestProfile(options) {
  const response = await fetch("/api/profile", options);
  if (response.status === 401) {
    window.location.replace("login.html");
    return null;
  }
  const data = await response.json();
  if (!response.ok) throw new Error(data.message);
  return data;
}

async function loadProfile() {
  showProfileStatus("Loading profile…");
  try {
    const profile = await requestProfile();
    if (!profile) return;
    const stateSelect = addressFields.state;
    if (
      profile.state &&
      !Array.from(stateSelect.options).some(
        (option) => option.value === profile.state,
      )
    ) {
      stateSelect.add(new Option(profile.state + " (saved)", profile.state));
    }
    for (const [name, input] of Object.entries(profileFields)) {
      input.value = profile[name] ?? "";
    }
    profileForm.hidden = false;
    showProfileStatus("");
  } catch {
    showProfileStatus(
      "Could not load your profile. Refresh the page to try again.",
      true,
    );
  }
}

profileForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  const invalidAddressField = validateAddress();
  if (invalidAddressField) {
    invalidAddressField.focus();
    return;
  }
  const submitButton = profileForm.querySelector('button[type="submit"]');
  const fields = Object.fromEntries(
    Object.entries(profileFields)
      .filter(([, input]) => !input.disabled)
      .map(([name, input]) => [name, input.value]),
  );
  submitButton.disabled = true;
  showProfileStatus("Saving…");
  try {
    const result = await requestProfile({
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(fields),
    });
    if (result) showProfileStatus(result.message);
  } catch (error) {
    showProfileStatus(
      error instanceof TypeError
        ? "Could not save your changes. Please try again."
        : error.message,
      true,
    );
  } finally {
    submitButton.disabled = false;
  }
});

document.getElementById("copyright-year").textContent =
  new Date().getFullYear();
loadProfile();

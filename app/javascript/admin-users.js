const initAdminUsers = () => {
  const statusButtons = document.querySelectorAll('[data-status-toggle]');
  const modal = document.getElementById('status-modal');

  if (!statusButtons.length || !modal) return;

  const overlay = modal.querySelector('[data-modal-dismiss]');
  const dismissTriggers = modal.querySelectorAll('[data-modal-dismiss]');
  const message = modal.querySelector('[data-modal-message]');
  const form = modal.querySelector('[data-modal-form]');
  const statusInput = modal.querySelector('[data-modal-input]');
  const submitButton = modal.querySelector('[data-modal-submit]');

  const showModal = () => {
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden', 'false');
  };

  const hideModal = () => {
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden', 'true');
  };

  statusButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const userName = button.dataset.userName || '';
      const currentStatus = button.dataset.userStatus;
      const toggleUrl = button.dataset.toggleUrl;
      const willDeactivate = currentStatus === 'active';

      const targetLabel = willDeactivate ? '無効' : '有効';
      message.textContent = `${userName} さんを${targetLabel}に変更します。よろしいですか？`;

      statusInput.value = willDeactivate ? 'true' : 'false';
      submitButton.textContent = `${targetLabel}にする`;
      form.setAttribute('action', toggleUrl);

      showModal();
    });
  });

  dismissTriggers.forEach((trigger) => {
    trigger.addEventListener('click', hideModal);
  });
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initAdminUsers);
} else {
  initAdminUsers();
}

import { registerWatcher } from 'dom_watcher';

const applyController = (node) => {
  if (!node.classList?.contains('accordion')) {
    return;
  }

  node.dataset.controller = 'accordion';

  node.querySelectorAll('.title').forEach((title) => {
    title.dataset.action = 'click->accordion#toggleContent';
  })
};

registerWatcher('nodeAdded', applyController);

document.addEventListener('DOMContentLoaded', function() {
  document.querySelectorAll('.ui.accordion').forEach(applyController);
});

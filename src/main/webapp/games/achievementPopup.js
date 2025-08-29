window.showAchievementPopup = function(title, description) {
    const $popup = $(`
        <div class="position-fixed start-50 translate-middle-x bg-dark text-white p-3 rounded shadow text-center"
             style="top: 20px; z-index: 1050; max-width: 90%; width: 400px; word-break: break-word;">
            <h5 class="text-warning mb-2">${title}</h5>
            <p class="mb-0">${description}</p>
        </div>
    `).appendTo('body');

    $popup.css('opacity', 0)
          .animate({ opacity: 1 }, 400)
          .delay(2500)
          .animate({ opacity: 0 }, 400, function() {
              $popup.remove();
          });
};
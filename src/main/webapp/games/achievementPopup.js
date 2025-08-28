window.showAchievementPopup = function(message) {
    const $popup = $('<div></div>')
        .text(message)
        .css({
            position: 'absolute',
            top: '30%',
            left: '50%',
            transform: 'translateX(-50%)',
            padding: '15px 30px',
            backgroundColor: '#222',
            color: '#fff',
            fontSize: '20px',
            borderRadius: '10px',
            zIndex: 9999,
            opacity: 0
        })
        .appendTo('body');

    $popup.animate({ opacity: 1 }, 300)
          .delay(2000)
          .animate({ opacity: 0 }, 300, function() {
              $popup.remove();
          });
};

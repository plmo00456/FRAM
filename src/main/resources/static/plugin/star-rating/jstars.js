/**!
 * jStars 1.0 | Nick Potafiy
 * https://github.com/nickpotafiy/jstars
 * Self-contained jQuery plugin for displaying star ratings.
 * @license
 */
!function($) {
    $.fn.jstars = function(s) {
        s = s || {};

		function unselectable($element) {
            $element.css("user-select", "none")
                .css("-moz-user-select", "none")
                .css("-khtml-user-select", "none")
                .css("-webkit-user-select", "none")
                .css("-o-user-select", "none");
        }

        function repeat(str, num) {
            return new Array(num + 1).join(str);
        }

        this.setValue = function(newValue) {
            this.each(function() {
                var $element = $(this);
                var totalStars = $element.data("total-stars") || d.stars;
                var $filledStars = $element.find('.jstars-filled');
                $filledStars.css('width', (newValue / totalStars) * 100 + '%');
            });
        };

        if (!this.data('initialized')) {
            var d = $.extend({
                size: "1.5rem",
                value: 0,
                stars: 5,
                color: "#4285F4",
                emptyColor: "#dddddd"
            }, s);

            this.each(function() {
                var $container = $(this);
                var value = $container.data('value') || d.value;
                var totalStars = $container.data('total-stars') || d.stars;
                var color = $container.data('color') || d.color;
                var emptyColor = $container.data('empty-color') || d.emptyColor;
                var size = $container.data('size') || d.size;

                var $emptyStars = $('<div>')
                    .addClass('jstars-empty')
                    .css('position', 'relative')
                    .css('display', 'inline-block')
                    .css('font-size', size)
                    .css('line-height', size)
                    .css('color', emptyColor)
                    .append(repeat("&starf;", totalStars));

                unselectable($emptyStars);

                var $filledStars = $('<div>')
                    .addClass('jstars-filled')
                    .css('top', 0)
                    .css('left', 0)
                    .css('position', 'absolute')
                    .css('display', 'inline-block')
                    .css('font-size', size)
                    .css('line-height', size)
                    .css('width', ((value / totalStars) * 100) + '%')
                    .css('overflow', 'hidden')
                    .css('white-space', 'nowrap')
                    .css('color', color)
                    .append(repeat("&starf;", totalStars));

                unselectable($filledStars);

                $emptyStars.append($filledStars);
                $container.append($emptyStars);
            });

            this.data('initialized', true);
        }

        return this;
    };
}(jQuery);

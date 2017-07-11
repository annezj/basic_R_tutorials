(function($) {
    $(document).ready(function() {
	
	$('#crime_animation').scianimator({
	    'images': ['images/crime_animation1.png', 'images/crime_animation2.png', 'images/crime_animation3.png', 'images/crime_animation4.png', 'images/crime_animation5.png', 'images/crime_animation6.png', 'images/crime_animation7.png', 'images/crime_animation8.png', 'images/crime_animation9.png', 'images/crime_animation10.png', 'images/crime_animation11.png', 'images/crime_animation12.png'],
	    'width': 800,
	    'delay': 1000,
	    'loopMode': 'loop'
	});
	$('#crime_animation').scianimator('play');
    });
})(jQuery);

<?php

// start with assuming no support for touch
add_filter('body_class', function($classes) {
    $classes[] = "no-touch";
    return $classes;
});

// Remove <html class="no-touch"> & set <html class="touch"> if browser support touch.
add_action('wp_footer', function() {
?>
  <script type="text/javascript">(function(a,b,e){b.addEventListener(e,function c(){b.removeEventListener(e,c,false),a.className=a.className.replace(/\bno-touch\b/,'touch')},false)})(document.body,document.body,'touchstart')</script>
<?php
});

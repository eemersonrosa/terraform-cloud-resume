$(document).ready(function () {
    // Cache selectors
    var $win = $(window);
    var $navbar = $('#header');
    var $toggle = $('.toggle-button');

    // Initial setup
    var width = $navbar.width();
    toggleOnClick($win, $navbar, width);

    // Resize event handler
    $win.resize(function () {
        toggleOnClick($win, $navbar, width);
    });

    // Toggle button click event
    $toggle.click(function () {
        $navbar.toggleClass("toggle-left");
    });

    // Typed.js initialization
    var typed = new Typed('#typed', {
        strings: ['Cloud DevOps Engineer'],
        typeSpeed: 55,
        backSpeed: 55,
        loop: true
    });

    var typed_2 = new Typed('#typed_2', {
        strings: ['Cloud DevOps Engineer'],
        typeSpeed: 55,
        backSpeed: 55,
        loop: true
    });

    // Smooth scroll to anchor links
    $('a[href^="#"]').on('click', function (e) {
        e.preventDefault();
        var target = $(this).attr('href');
        $(target).get(0).scrollIntoView({
            behavior: 'smooth'
        });
    });

    // Uncomment to enable counter update
    // const counter = document.querySelector(".counter-number");
    // async function updateCounter() {
    //     try {
    //         let response = await fetch("lambda-url.us-east-1.on.aws/");
    //         let data = await response.json();
    //         counter.innerHTML = `Views: ${data}`;
    //     } catch (error) {
    //         console.error('Failed to fetch counter data:', error);
    //     }
    // }
    // updateCounter();
});

function toggleOnClick($win, $navbar, width) {
    if ($win.width() <= 768) {
        $navbar.css({ left: `-${width}px` });
    } else {
        $navbar.css({ left: '0px' });
    }
}

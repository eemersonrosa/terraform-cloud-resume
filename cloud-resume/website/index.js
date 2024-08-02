$(document).ready(function () {
  // Cache selectors for window, navbar, and toggle button
  var $win = $(window);
  var $navbar = $("#header");
  var $toggle = $(".toggle-button");

  // Get the initial width of the navbar
  var width = $navbar.width();

  // Initial setup: adjust navbar position based on window width
  toggleOnClick($win, $navbar, width);

  // Handle window resize event to adjust navbar position
  $win.resize(function () {
    toggleOnClick($win, $navbar, width);
  });

  // Handle toggle button click event to show/hide navbar
  $toggle.click(function () {
    $navbar.toggleClass("toggle-left");
  });

  // Initialize Typed.js for text animation
  var typed = new Typed("#typed", {
    strings: ["DevOps Engineer"],
    typeSpeed: 55,
    backSpeed: 55,
    loop: true,
  });

  var typed_2 = new Typed("#typed_2", {
    strings: ["DevOps Engineer"],
    typeSpeed: 55,
    backSpeed: 55,
    loop: true,
  });

  // Smooth scroll to anchor links
  $('a[href^="#"]').on("click", function (e) {
    e.preventDefault();
    var target = $(this).attr("href");
    $(target).get(0).scrollIntoView({
      behavior: "smooth",
    });
  });

  // Uncomment the following code to enable counter update
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

// Function to adjust navbar position based on window width
function toggleOnClick($win, $navbar, width) {
  if ($win.width() <= 768) {
    // Hide navbar if window width is less than or equal to 768px
    $navbar.css({ left: `-${width}px` });
  } else {
    // Show navbar if window width is greater than 768px
    $navbar.css({ left: "0px" });
  }
}

// ocultar los productos excepto
document.addEventListener("DOMContentLoaded", () => {
    let boxes = [...document.querySelectorAll('.box-container .box')];

    boxes.forEach((box, index) => {
        if (index < 5) {
            box.style.display = 'inline-block';  
        } else {
            box.style.display = 'none';         
        }
    });
});

// Número de productos visibles inicialmente
let currentItem = 5;

// Botón cargar productos +5
const loadMoreBtn = document.getElementById('load-more');

loadMoreBtn.onclick = () => {
    let boxes = [...document.querySelectorAll('.box-container .box')];

    for (let i = currentItem; i < currentItem + 5 && i < boxes.length; i++) {
        boxes[i].style.display = 'inline-block';
    }

    currentItem += 5;

    if (currentItem >= boxes.length) {
        loadMoreBtn.style.display = 'none';
    }
};

const addProd = function(e){
  const addingProducts = document.getElementById('adding-products');
  const container = document.getElementById('form-container');
  const forms = document.getElementById('form');
  const newForms = forms.cloneNode(true);
  container.append(newForms);
  console.log(newForms);
}

const addProdClick = function(e){
  const addProdButton = document.getElementById('addProd');
  addProdButton.addEventListener("click", function() {
      addProd()
  })
};

document.addEventListener("turbolinks:load", function() {
  addProdClick();
})
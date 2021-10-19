const addProd = function(e){
  const addProdButton = document.getElementById('addProd');
  const addingProducts = document.getElementById('adding-products');
  const forms = document.getElementById('forms')
  const newForms = 0;
  addProdButton.addEventListener("click", function() {
      forms.append("<div><%= render partial: 'sales/form', locals: { form: form } %></div>");
      console.log("newForms");
  })
}

document.addEventListener("turbolinks:load", function() {
  addProd();
})
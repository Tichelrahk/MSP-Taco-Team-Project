async function fetchAsync (url) {
  let response = await fetch(url);
  let data = await response;
  window.location.href = url;
}

const Search = function(e){
  const bar = document.getElementById('search');
  const query = bar.value;
  const baseURL = "/";
  let url = baseURL + `?query=${query}`
  fetchAsync (url);
};

const SearchFunction = function(e){
	const searchButton = document.getElementById('searchButton');
	searchButton.addEventListener("click", function() {
  		Search()
	})
};


document.addEventListener("turbolinks:load", function() {
  SearchFunction();
})

  // searchAPICall: function (event) {
  //   const page = this
  //   console.log(21, event)
  //   const query = event.detail.value
  //   console.log(22, query)
  //   wx.request({
  //     url: app.globalData.url + "events" + `?query=${query}`,
  //     method: 'GET',
  //     success(res) {
  //       console.log(11, res)
  //       const events = res.data.events
  //       // page.setData({events})
  //       page.setData({
  //         events: events
  //       });
  //       console.log(10, events)
  //     }
  //   })
  // },
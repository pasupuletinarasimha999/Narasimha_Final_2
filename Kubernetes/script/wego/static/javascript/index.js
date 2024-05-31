/**
 * Created by Ritesh on 7/28/2018.
 */
var orders = [];
function itemAdded(itemName,size) {
    var article = document.getElementById(itemName+'-'+size)
    article.value = parseInt(article.value) + 1;
    console.log(article.dataset.drinkType, itemName, article.value, size, article.dataset.price);
    var existItem = orders.find(function (ele) {
        if(ele.name === itemName && ele.size === size){
            ele.value = article.value;
            ele.price = (parseInt(article.value)*article.dataset.price).toFixed(2);
            return ele
        }
    })
    if(!existItem){
        orders.push({type: article.dataset.drinkType, name: itemName, value: article.value, size: size, price: article.dataset.price})
    }
    insertOrder(orders);
}

function insertOrder(orders) {
    var table = document.getElementById("orderTable");
    console.log(orders)
    if(table.rows.length !== 1){
        var tableHeaderRowCount = 1;
        var rowCount = table.rows.length;
        for (var i = tableHeaderRowCount; i < rowCount; i++) {
            table.deleteRow(tableHeaderRowCount);
        }
    }
    orders.forEach(function (ele, index) {
        var row = table.insertRow(table.rows.length);
        row.insertCell(0).innerHTML = '<button type="button" class="btn btn-danger btn-sm" id='+index+' onclick="deleteOrderRow(this)"><i class="fas fa-trash-alt"></i></button>';
        row.insertCell(1).innerHTML = ele.name;
        row.insertCell(2).innerHTML = ele.size;
        row.insertCell(3).innerHTML = ele.value;
        row.insertCell(4).innerHTML = ele.price;
    })
}

function deleteOrderRow(row) {
    var row = row.parentNode.parentNode;
    row.parentNode.removeChild(row);
    orders = orders.filter(function (ele) {
       if(ele.name === row.cells[1].innerText & ele.size === row.cells[2].innerText){}
       else{return true}
    })
    console.log('order after', orders);
}

function itemSubtract(itemName,size) {
    var article = document.getElementById(itemName+'-'+size)
    if(parseInt(article.value) !== 0) {
        article.value = parseInt(article.value) - 1;
        orders.find(function (ele) {
            if(ele.name === itemName && ele.size === size) {
                ele.value = article.value
                if(parseInt(ele.value) === 0){
                    orders = orders.filter(function (ele) {
                        return (parseInt(ele.value) != 0)
                    });
                }
            }
        })
    }
    insertOrder(orders);
}


function submitOrder() {
    console.log('submitOrder')
    var requestPayload = {}
    requestPayload['orders'] = orders
    console.log(requestPayload)
    console.log('jon', JSON.stringify(requestPayload))
    $.ajax({
        url: 'http://localhost:8000/coffeeshop/api/order/',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(requestPayload),
        success : function (response) {
            console.log('got response', response)
            alert('Thank you! order is placed')
            location.reload(true)
        }
    })
}
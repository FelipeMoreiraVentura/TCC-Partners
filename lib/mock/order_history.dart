Future<Map<String, List>> getOrderHistory() async {
  await Future.delayed(Duration(seconds: 2)); // Simula chamada assíncrona

  return {
    "orders": [
      {
        "order_id": "ORD123456",
        "date": "2025-04-01T14:30:00Z",
        "status": "Delivered",
        "total": 1299.99,
        "items": [
          {
            "id": "123456",
            "name": "Smartphone XYZ 128GB Black",
            "quantity": 1,
            "price": 1299.99,
            "image":
                "https://down-br.img.susercontent.com/file/br-11134207-7r98o-m521w5egt1v6c8",
          },
        ],
        "shipping_address": {
          "recipient": "João da Silva",
          "street": "Rua Exemplo, 123",
          "city": "São Paulo",
          "state": "SP",
          "zip": "01234-567",
        },
      },
      {
        "order_id": "ORD123457",
        "date": "2025-03-20T10:00:00Z",
        "status": "Shipped",
        "total": 479.98,
        "items": [
          {
            "id": "234567",
            "name": "Wireless Headphones ABC",
            "quantity": 2,
            "price": 239.99,
            "image":
                "https://down-br.img.susercontent.com/file/sg-11134201-7rbmd-lln9asx41jfz24",
          },
        ],
        "shipping_address": {
          "recipient": "João da Silva",
          "street": "Rua Exemplo, 123",
          "city": "São Paulo",
          "state": "SP",
          "zip": "01234-567",
        },
      },
    ],
  };
}

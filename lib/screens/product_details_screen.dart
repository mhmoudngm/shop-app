import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/providers/product.dart';
import 'package:shop_flutter_app/providers/products.dart';
import 'package:shop_flutter_app/screens/edit_product_screen.dart';
import 'package:shop_flutter_app/widgets/products_grid.dart';

class productdetailsscreen extends StatefulWidget {
  @override
  State<productdetailsscreen> createState() => _productdetailsscreenState();
}

class _productdetailsscreenState extends State<productdetailsscreen> {
  final _pricefocusnode = FocusNode();
  final _descriptionfocusnode = FocusNode();
  final _imgurlfocusnode = FocusNode();
  final imgcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  var _editingproduct =
      product(id: '', title: '', description: '', price: 0, imgurl: '');
  var initalvalues = {
    'title': '',
    'description': '',
    'price': '',
    'imgurl': '',
  };
  var isinit = true;
  var isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imgurlfocusnode.addListener(_updateimgurl);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (isinit) {
      final productid = ModalRoute.of(context)?.settings.arguments as String?;
      if (productid != null) {
        _editingproduct = Provider.of<products>(context,listen: false).findbyid(productid);
        initalvalues = {
          'title': _editingproduct.title,
          'description': _editingproduct.description,
          'price': _editingproduct.price.toString(),
          'imgurl': '',
        };
        imgcontroller.text = _editingproduct.imgurl;
      }
      
      isinit = false;
    }
  }


  void _updateimgurl() {
    if (!_imgurlfocusnode.hasFocus) {
      if ((!imgcontroller.text.startsWith('http') &&
              !imgcontroller.text.startsWith('https')) ||
          (!imgcontroller.text.endsWith('.png') &&
              !imgcontroller.text.endsWith('.jpg') &&
              !imgcontroller.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveform() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formkey.currentState!.save();
    setState(() {
      isloading = true;
    });
    if (_editingproduct.id != '') {
      await Provider.of<products>(context, listen: false)
          .updateproduct(_editingproduct.id, _editingproduct);
    } 
    else {
      try {
        await Provider.of<products>(context, listen: false)
            .addproduct(_editingproduct);
            
      } 
      catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("an error accurred!"),
                  content: Text("some thing went wrong"),
                  actions: [
                    FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text("okey"))
                  ],
                ));
      }
      
    }
    setState(() {
        isloading = false;
      });

      Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product"),
          actions: [
            IconButton(onPressed: saveform, icon: Icon(Icons.save))
          ],
        ),
        body: Container(
          
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.deepOrange.withOpacity(0.5),
              Colors.amber.withOpacity(0.9)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formkey,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: initalvalues['title'] as String,
                          decoration: InputDecoration(labelText: ("Title")),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_pricefocusnode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("please provide a value");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) {
                            _editingproduct = product(
                                description: _editingproduct.description,
                                imgurl: _editingproduct.imgurl,
                                id: _editingproduct.id,
                                isfavorite: _editingproduct.isfavorite,
                                price: _editingproduct.price,
                                title: val as String);
                          },
                        ),
                        TextFormField(
                          initialValue: initalvalues['price'] as String,
                          decoration: InputDecoration(labelText: ("Price")),
                          keyboardType: TextInputType.number,
                          focusNode: _pricefocusnode,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionfocusnode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("please enter a price");
                            }
                            if (double.tryParse(value) == null) {
                              return ("please enter avalid number");
                            }
                            if (double.parse(value) <= 0) {
                              return ("please enter a price greater than zero");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) {
                            _editingproduct = product(
                                description: _editingproduct.description,
                                imgurl: _editingproduct.imgurl,
                                id: _editingproduct.id,
                                isfavorite: _editingproduct.isfavorite,
                                price: double.parse(val!),
                                title: _editingproduct.title);
                          },
                        ),
                        TextFormField(
                          initialValue: initalvalues['description'] as String,
                          focusNode: _descriptionfocusnode,
                          decoration: InputDecoration(labelText: ("description")),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("please enter a description");
                            }
                            if (value.length <= 10) {
                              return ("Should be at least 10 characters");
                            } else {
                              return null;
                            }
                          },
                          onSaved: (val) {
                            _editingproduct = product(
                                description: val as String,
                                imgurl: _editingproduct.imgurl,
                                id: _editingproduct.id,
                                isfavorite: _editingproduct.isfavorite,
                                price: _editingproduct.price,
                                title: _editingproduct.title);
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                
                                  border: Border.all(width: 1, color: Colors.grey)),
                              child: imgcontroller.text.isEmpty
                                  ? FittedBox(
                                      child: Image.asset(
                                        'assets/images/i.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                        imgcontroller.text,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                            Expanded(child: 
                  
                             TextFormField(
                          controller: imgcontroller,
                          keyboardType:TextInputType.url,
                          focusNode: _imgurlfocusnode,
                         
                          decoration: InputDecoration(labelText: ("imgurl")),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return ("please enter a image url");
                            }
                            if(!value.startsWith("http")&&!value.startsWith("https"))
                            {
                              return("please enter avalid image url");
                            }
                           // if(!value.endsWith("jpg")&&!value.endsWith("png")&&!value.endsWith("jpeg"))
                            //{
                             // return("please enter avalid image url");
                           // }
                             else {
                              return null;
                            }
                          },
                          onSaved: (val) {
                            _editingproduct = product(
                                description: _editingproduct.description,
                                imgurl: val as String,
                                id: _editingproduct.id,
                                isfavorite: _editingproduct.isfavorite,
                                price: _editingproduct.price,
                                title: _editingproduct.title);
                          },
                        ),
                            
                  
                  
                  
                  
                  
                  
                            
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
        ));
  }
}

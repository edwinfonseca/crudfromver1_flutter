import 'package:flutter/material.dart';
import 'package:fromcrudbloc/src/bloc/provider.dart';
import 'package:fromcrudbloc/src/models/producto_model.dart';
import 'package:fromcrudbloc/src/providers/productos_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    //final bloc = Provider.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(ProdcutosBloc prodcutosBloc) {
    return StreamBuilder(
        stream: prodcutosBloc.productosStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) =>
                    _crearItems(context, prodcutosBloc, productos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    /*return FutureBuilder(
        future: productosProvider.cargarProductos(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
                itemCount: productos.length,
                itemBuilder: (context, i) =>
                    _crearItems(context, productos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });*/
  }

  Widget _crearItems(BuildContext context, ProdcutosBloc prodcutosBloc,
      ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          prodcutosBloc.borrarProducto(producto.id);
          //productosProvider.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: [
              (producto.fotoUrl == null)
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(producto.fotoUrl),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'producto',
                        arguments: producto)
                    .then((value) => setState(() {})),
              ),
            ],
          ),
        ));
  }

  _crearBoton(context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.orangeAccent,
        onPressed: () => Navigator.pushNamed(context, 'producto')
            .then((value) => (value) => setState(() {})));
  }
}

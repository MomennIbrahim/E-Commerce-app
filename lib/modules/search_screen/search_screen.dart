import 'package:buildcondition/buildcondition.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit.dart';
import 'package:shop_app/modules/product_details.dart';
import 'package:shop_app/modules/search_screen/search_cubit.dart';
import 'package:shop_app/modules/search_screen/search_state.dart';
import 'package:shop_app/share/components/components.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: searchController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(28.0)),
                            label: const Text('البحث'),
                            filled: true,
                            fillColor: Colors.deepPurple[50],
                            iconColor: Theme.of(context).primaryColor),
                        onFieldSubmitted: (String? value) {
                              SearchCubit.get(context).getSearch(value);
                              },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الحقل فارغ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 15.0,),
                    if(state is SearchLoadingState)
                      const LinearProgressIndicator(),
                    const SizedBox(height: 15.0,),
                    BuildCondition(
                        condition: SearchCubit.get(context).searchModel != null,
                        builder: (context)=>Expanded(
                          child: SearchCubit.get(context).searchModel!.data!.data!.isNotEmpty ? ListView.builder(
                            itemBuilder: (context, index) {
                              return buildSearchItem(SearchCubit.get(context).searchModel!.data!.data![index], context, index);
                            },
                            itemCount:SearchCubit.get(context).searchModel!.data!.data!.length,
                          ): Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              defaultText(text: 'لم يتم العصور علي اي عنصر'),
                              defaultText(text: 'حاول مرة اخرى',color: Colors.black45),
                            ],
                          ),
                        ),
                        fallback: (context)=> Center(child: Container(),),
                      )
                  ],
                ),
              ));
        },
      ),
    );
  }
}

buildSearchItem(model, context ,int index) {
  return SizedBox(
    width: double.infinity,
    height: 170.0,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4.0),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Card(
            elevation: 2.5,
            shadowColor: Colors.deepPurple,
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                width: 150,
                height: 120.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          '${model.image}'),)),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        '${model.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                          'EGP',
                          style: TextStyle(
                              decoration:
                             1 !=
                                  0
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: Colors.black,
                              fontSize: 18.0)),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (1!= 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: defaultText(
                            text:
                            'discount %',
                            color: Colors.green,
                            size: 17,
                            fontWeight: FontWeight.bold),
                      ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                ShopCubit.get(context).changeFavourites(
                                    model.id!);
                              },
                              icon: ShopCubit.get(context).favourites[
                              model.id] ==
                                  true
                                  ? const Icon(
                                EvaIcons.star,
                                color: Colors.deepPurple,
                                size: 22.5,
                              )
                                  : const Icon(
                                EvaIcons.starOutline,
                                color: Colors.deepPurple,
                                size: 22.5,
                              )),
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                navigateTo(
                                    context,
                                    ProductDetails(
                                      currentIndex: index,
                                    ));
                              },
                              icon: const Icon(
                                EvaIcons.moreVertical,
                                size: 20.0,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    ),
  );
}

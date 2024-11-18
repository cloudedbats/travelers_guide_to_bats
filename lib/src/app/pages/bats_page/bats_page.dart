import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/bats_cubit.dart';
import '../../../data/model/taxa_info.dart';
import '../../../core/get_data.dart';

class BatListView extends StatefulWidget {
  const BatListView({
    super.key,
  });

  @override
  State<BatListView> createState() => _BatListViewState();
}

class _BatListViewState extends State<BatListView> {
  String? filterString;

  @override
  void initState() {
    super.initState();
    filterString = BlocProvider.of<BatsCubit>(context).lastUsedFilter();
    BlocProvider.of<BatsCubit>(context).filterBatsByString(filterString ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 50, 5),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Scientific or common name filter',
                  ),
                  // initialValue: BatsCubit.getLastUsedFilterString(),
                  initialValue: filterString,
                  onChanged: (String? value) {
                    setState(() {
                      filterString = value;
                    });
                    context.read<BatsCubit>().filterBatsByString(value ?? '');
                  },
                ),
              ),
              Expanded(
                child: BlocConsumer<BatsCubit, BatsState>(
                  listenWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    if (state.batsResult.status == BatsStatus.initial) {
                      context
                          .read<BatsCubit>()
                          .filterBatsByString(filterString ?? '');
                    }
                  },
                  buildWhen: (previous, current) {
                    return true;
                  },
                  builder: (context, state) {
                    if (state.batsResult.status == BatsStatus.success) {
                      var batList = state.batsResult.filteredBats;
                      return ListView.builder(
                        itemCount: batList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(batList[index].scientificName,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            // subtitle: Text(ByCountry[index].commonName),
                            subtitle: Text(
                                '${batList[index].taxonFamily}    ${batList[index].commonName}'),
                            trailing: Text(
                                '${batList[index].redListCategory}\n${index + 1} (${batList.length})'),
                            onTap: () {
                              showSpeciesListDialog(context, batList, index);
                            },
                          ),
                        ),
                      );
                    } else if (state.batsResult.status == BatsStatus.initial) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.batsResult.status == BatsStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.batsResult.status == BatsStatus.failure) {
                      return Center(child: Text(state.batsResult.message));
                    } else {
                      return const Placeholder();
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<dynamic> showSpeciesListDialog(
      BuildContext context, List<TaxonInfo> batList, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            // Close, many alternatives.
            // child: TextButton(
            //   onPressed: () { Navigator.pop(context); },
            // child: InkWell(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topRight,
                      // Close, many alternatives.
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close)),
                    ),
                    // Text(
                    //   '${countryList[index].countryName}\n\n',
                    //   style: const TextStyle(
                    //       // fontStyle: FontStyle.italic,
                    //       fontWeight: FontWeight.bold),
                    // ),
                    Html(
                      // style: ,
                      data: countryListBySpeciesy(batList[index].scientificName,
                          batList[index].commonName, batList[index].taxonId),
                    ),
                    // const SizedBox(height: 15),
                    // Close, many alternatives.
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String countryListBySpeciesy(
      String scientificName, String commonName, String taxonId) {
    return getCountriesBySpeciesAsHtml(scientificName, commonName, taxonId);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/model.dart' as model;
import '../main_page/cubit/data_cubit.dart';
import 'cubit/by_country_cubit.dart';
import '../../../data/model/taxa_info.dart';
import '../../../core/get_data.dart';

class ByCountryView extends StatefulWidget {
  const ByCountryView({
    super.key,
  });
  @override
  State<ByCountryView> createState() => _ByCountryViewState();
}

class _ByCountryViewState extends State<ByCountryView> {
  String? filterString;

  @override
  void initState() {
    super.initState();
    filterString = BlocProvider.of<ByCountryCubit>(context).lastUsedFilter();
    // BlocProvider.of<ByCountryCubit>(context).filterByCountryByString(filterString ?? '');
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocConsumer<DataCubit, DataState>(
                      listener: (context, state) {
                        // String enumAsString = state.dataResult.status.name;
                        // print('Data status 1: $enumAsString');
                        if (state.dataResult.status == DataStatus.success) {
                          BlocProvider.of<ByCountryCubit>(context)
                              .filterByCountryByString(filterString ?? '');
                        }
                      },
                      buildWhen: (previous, current) {
                        return true;
                      },
                      builder: (context, state) {
                        if (state.dataResult.status == DataStatus.success) {
                          return DropdownButton(
                            // isDense: false,
                            // isExpanded: true,
                            hint: const Text('Select country'),
                            items: model.countries.map((model.Country item) {
                              return DropdownMenuItem(
                                  value: item.countryCode,
                                  child: Text(
                                    // softWrap: true,
                                    // overflow: TextOverflow.ellipsis,
                                    item.countryName,
                                  ));
                            }).toList(),
                            value: filterString,
                            // value: BlocProvider.of<ByCountryCubit>(context).lastUsedFilter(),
                            // value: state.byCountryResult.filterString,
                            onChanged: (String? value) {
                              setState(() {
                                filterString = value;
                              });
                              context
                                  .read<ByCountryCubit>()
                                  .filterByCountryByString(value ?? '');
                            },
                          );
                        } else {
                          return DropdownButton(
                            hint: const Text('Select country'),
                            items: [],
                            value: null,
                            // value: BlocProvider.of<ByCountryCubit>(context).lastUsedFilter(),
                            // value: state.byCountryResult.filterString,
                            onChanged: (value) {
                              setState(() {
                                filterString = value.toString();
                              });
                              //   context
                              //       .read<ByCountryCubit>()
                              //       .filterByCountryByString(value ?? '');
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                // child: Builder(
                child: BlocConsumer<ByCountryCubit, ByCountryState>(
                  listenWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    // String enumAsString = state.byCountryResult.status.name;
                    // print('ByCountry status 1: $enumAsString');

                    if (state.byCountryResult.status ==
                        ByCountryStatus.failure) {
                      Center(child: Text(state.byCountryResult.message));
                    }
                    if (state.byCountryResult.status ==
                        ByCountryStatus.success) {
                      // String? value = BlocProvider.of<ByCountryCubit>(context).lastUsedFilter();
                      // context.read<ByCountryCubit>().filterByCountryByString(value ?? '');
                    }
                  },
                  buildWhen: (previous, current) {
                    if (current.byCountryResult.status ==
                        ByCountryStatus.success) {
                      return true;
                    }
                    return true;
                  },
                  builder: (context, state) {
                    // builder: (context) {
                    // print(state.byCountryResult.status);
                    if (state.byCountryResult.status ==
                        ByCountryStatus.success) {
                      var byCountry = state.byCountryResult.filteredByCountry;
                      return ListView.builder(
                        itemCount: byCountry.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(byCountry[index].scientificName,
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            // subtitle: Text(ByCountry[index].commonName),
                            subtitle: Text(
                                '${byCountry[index].taxonFamily}    ${byCountry[index].commonName}'),
                            trailing: Text(
                                '${byCountry[index].redListCategory}\n${index + 1} (${byCountry.length})'),
                            onTap: () {
                              showSpeciesListDialog(context, byCountry, index);
                            },
                          ),
                        ),
                      );
                    } else if (state.byCountryResult.status ==
                        ByCountryStatus.initial) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.byCountryResult.status ==
                        ByCountryStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.byCountryResult.status ==
                        ByCountryStatus.failure) {
                      return Center(child: Text(state.byCountryResult.message));
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
          padding: const EdgeInsets.all(2.0),
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
                padding: const EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
                child: SelectionArea(
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
                          data: countryListBySpecies(
                            batList[index].scientificName,
                            batList[index].commonName,
                            batList[index].taxonFamily,
                            batList[index].redListCategory,
                            batList[index].taxonId,
                          ),
                      ),
                      // const SizedBox(height: 15),
                      // Close, many alternatives.
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: SelectionContainer.disabled(
                              child: const Text('Close')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String countryListBySpecies(
    String scientificName,
    String commonName,
    String taxonFamily,
    String redListCategory,
    String taxonId,
  ) {
    return getCountriesBySpeciesAsHtml(
        scientificName, commonName, taxonFamily, redListCategory, taxonId);
  }
}

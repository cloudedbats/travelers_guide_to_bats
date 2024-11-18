import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/countries_cubit.dart';
import '../../../data/model/countries.dart';
import '../../../core/get_data.dart';

class CountryListView extends StatefulWidget {
  const CountryListView({
    super.key,
  });

  @override
  State<CountryListView> createState() => _CountryListViewState();
}

class _CountryListViewState extends State<CountryListView> {
  String? filterString;

  @override
  void initState() {
    super.initState();
    filterString = BlocProvider.of<CountriesCubit>(context).lastUsedFilter();
    BlocProvider.of<CountriesCubit>(context)
        .filterCountryByString(filterString ?? '');
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
                    labelText: 'Country name/code filter',
                  ),
                  // initialValue: CountriesCubit.getLastUsedFilterString(),
                  initialValue: filterString,
                  onChanged: (String? value) {
                    setState(() {
                      filterString = value;
                    });
                    context
                        .read<CountriesCubit>()
                        .filterCountryByString(value ?? '');
                  },
                ),
              ),
              Expanded(
                child: BlocConsumer<CountriesCubit, CountriesState>(
                  listenWhen: (previous, current) {
                    return true;
                  },
                  listener: (context, state) {
                    if (state.countriesResult.status ==
                        CountriesStatus.initial) {
                      context
                          .read<CountriesCubit>()
                          .filterCountryByString(filterString ?? '');
                    }
                  },
                  buildWhen: (previous, current) {
                    return true;
                  },
                  builder: (context, state) {
                    if (state.countriesResult.status ==
                        CountriesStatus.success) {
                      var countryList = state.countriesResult.filteredCountries;
                      return ListView.builder(
                        itemCount: countryList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(countryList[index].countryName),
                            // trailing: Text(countryList[index].countryCode),
                            trailing: Text(
                              '${countryList[index].countryCode}\n${index + 1} (${countryList.length})',
                            ),
                            onTap: () {
                              showSpeciesListDialog(
                                  context, countryList, index);
                            },
                          ),
                        ),
                      );
                    } else if (state.countriesResult.status ==
                        CountriesStatus.initial) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.countriesResult.status ==
                        CountriesStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.countriesResult.status ==
                        CountriesStatus.failure) {
                      return Center(child: Text(state.countriesResult.message));
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
      BuildContext context, List<Country> countryList, int index) {
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
                      data: speciesListByCountry(countryList[index].countryName,
                          countryList[index].countryCode),
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

  String speciesListByCountry(String countryName, String countryCode) {
    return getSpeciesByCountryAsHtml(countryName, countryCode);
  }
}

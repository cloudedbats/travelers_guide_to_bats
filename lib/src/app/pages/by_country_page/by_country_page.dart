import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/model.dart' as model;
import '../main_page/cubit/data_cubit.dart';
import 'cubit/by_country_cubit.dart';

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
                        // String enumAsString = state.dataResultData.status.name;
                        // print('Data status 1: $enumAsString');
                        if (state.dataResultData.status == DataStatus.success) {
                          BlocProvider.of<ByCountryCubit>(context)
                              .filterByCountryByString(filterString ?? '');
                        }
                      },
                      buildWhen: (previous, current) {
                        return true;
                      },
                      builder: (context, state) {
                        if (state.dataResultData.status == DataStatus.success) {
                          return DropdownButton(
                            hint: const Text('Select country'),
                            items: model.countries.map((model.Country item) {
                              return DropdownMenuItem(
                                  value: item.countryCode,
                                  child: Text(item.countryName));
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
                      // TODO: Use widget instead.
                      print(
                          'Exception Data 1: ${DataCubit.getLastException()}');
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
                            trailing: Text(byCountry[index].redListCategory),
                          ),
                        ),
                      );
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
}

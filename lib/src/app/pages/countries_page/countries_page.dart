import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/countries_cubit.dart';

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
                      var countryList =
                          state.countriesResult.filteredCountries;
                      return ListView.builder(
                        itemCount: countryList.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            title: Text(countryList[index].countryName),
                            // trailing: Text(countryList[index].countryCode),
                            trailing: Text(
                                '${countryList[index].countryCode}\n${index + 1} (${countryList.length})'),
                          ),
                        ),
                      );
                    } else if (state.countriesResult.status == CountriesStatus.initial) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.countriesResult.status == CountriesStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.countriesResult.status == CountriesStatus.failure) {
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
}

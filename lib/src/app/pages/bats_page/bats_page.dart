import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/bats_cubit.dart';

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
}

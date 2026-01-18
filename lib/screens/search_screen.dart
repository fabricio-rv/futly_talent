import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../providers/player_provider.dart';
import '../providers/post_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  SearchFilters _filters = SearchFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadAllPlayers();
      context.read<PostProvider>().loadFeedPosts();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filtros avançados',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _FilterSection(
                      title: 'Posições',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: PlayerPosition.values.map((position) {
                          final selected =
                              _filters.positions?.contains(position) ?? false;
                          return FilterChip(
                            label: Text(_positionLabel(position)),
                            selected: selected,
                            onSelected: (value) {
                              final current = List<PlayerPosition>.from(
                                _filters.positions ?? [],
                              );
                              if (value) {
                                current.add(position);
                              } else {
                                current.remove(position);
                              }
                              setModalState(() {
                                _filters = _filters.copyWith(
                                  positions: current.isEmpty ? null : current,
                                );
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    _FilterSection(
                      title: 'Pé preferido',
                      child: DropdownButton<Foot>(
                        isExpanded: true,
                        value: _filters.preferredFoot,
                        hint: const Text('Selecione'),
                        items: Foot.values
                            .map(
                              (foot) => DropdownMenuItem(
                                value: foot,
                                child: Text(_footLabel(foot)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            _filters = _filters.copyWith(preferredFoot: value);
                          });
                        },
                      ),
                    ),
                    _FilterSection(
                      title: 'Idade',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Mín',
                              ),
                              onChanged: (value) {
                                final min = int.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(ageMin: min);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Máx',
                              ),
                              onChanged: (value) {
                                final max = int.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(ageMax: max);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _FilterSection(
                      title: 'Altura (cm)',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Mín',
                              ),
                              onChanged: (value) {
                                final min = double.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(heightMin: min);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Máx',
                              ),
                              onChanged: (value) {
                                final max = double.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(heightMax: max);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _FilterSection(
                      title: 'Peso (kg)',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Mín',
                              ),
                              onChanged: (value) {
                                final min = double.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(weightMin: min);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Máx',
                              ),
                              onChanged: (value) {
                                final max = double.tryParse(value);
                                setModalState(() {
                                  _filters = _filters.copyWith(weightMax: max);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _FilterSection(
                      title: 'Status',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: PlayerStatus.values.map((status) {
                          final selected =
                              _filters.statuses?.contains(status) ?? false;
                          return FilterChip(
                            label: Text(_statusLabel(status)),
                            selected: selected,
                            onSelected: (value) {
                              final current = List<PlayerStatus>.from(
                                _filters.statuses ?? [],
                              );
                              if (value) {
                                current.add(status);
                              } else {
                                current.remove(status);
                              }
                              setModalState(() {
                                _filters = _filters.copyWith(
                                  statuses: current.isEmpty ? null : current,
                                );
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    _FilterSection(
                      title: 'Criação',
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _filters.creation,
                        hint: const Text('Futly ou Comunidade'),
                        items: const [
                          DropdownMenuItem(
                            value: 'futly',
                            child: Text('Futly'),
                          ),
                          DropdownMenuItem(
                            value: 'community',
                            child: Text('Comunidade'),
                          ),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            _filters = _filters.copyWith(creation: value);
                          });
                        },
                      ),
                    ),
                    _FilterSection(
                      title: 'Verificado',
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Somente verificados'),
                        value: _filters.isVerified ?? false,
                        onChanged: (value) {
                          setModalState(() {
                            _filters = _filters.copyWith(isVerified: value);
                          });
                        },
                      ),
                    ),
                    _FilterSection(
                      title: 'Potencial',
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: Potential.values.map((potential) {
                          final selected =
                              _filters.potentials?.contains(potential) ?? false;
                          return FilterChip(
                            label: Text(_potentialLabel(potential)),
                            selected: selected,
                            onSelected: (value) {
                              final current = List<Potential>.from(
                                _filters.potentials ?? [],
                              );
                              if (value) {
                                current.add(potential);
                              } else {
                                current.remove(potential);
                              }
                              setModalState(() {
                                _filters = _filters.copyWith(
                                  potentials: current.isEmpty ? null : current,
                                );
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    _FilterSection(
                      title: 'Risco de lesão',
                      child: DropdownButton<InjuryRisk>(
                        isExpanded: true,
                        value: _filters.injuryRisk,
                        hint: const Text('Selecione'),
                        items: InjuryRisk.values
                            .map(
                              (risk) => DropdownMenuItem(
                                value: risk,
                                child: Text(_riskLabel(risk)),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setModalState(() {
                            _filters = _filters.copyWith(injuryRisk: value);
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                _filters = SearchFilters();
                              });
                              context.read<PlayerProvider>().clearFilters();
                            },
                            child: const Text('Limpar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<PlayerProvider>().applyFilters(
                                    _filters,
                                  );
                              Navigator.pop(context);
                            },
                            child: const Text('Aplicar filtros'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    final postProvider = context.watch<PostProvider>();

    final query = _controller.text.trim().toLowerCase();
    final postResults = postProvider.feedPosts.where((post) {
      if (query.isEmpty) return true;
      final caption = post.caption?.toLowerCase() ?? '';
      return caption.contains(query) ||
          post.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          title: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Pesquisar jogadores, clubes, tags…',
              border: InputBorder.none,
            ),
            onChanged: (value) {
              context.read<PlayerProvider>().searchPlayers(value);
              setState(() {});
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _openFilters,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Jogadores'),
              Tab(text: 'Posts'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (playerProvider.recentSearches.isNotEmpty) ...[
                  Text(
                    'Pesquisas recentes',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: playerProvider.recentSearches
                        .map(
                          (item) => ActionChip(
                            label: Text(item),
                            onPressed: () {
                              _controller.text = item;
                              context
                                  .read<PlayerProvider>()
                                  .searchPlayers(item);
                              setState(() {});
                            },
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  'Explorar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: const [
                    Chip(label: Text('Destaques da semana')),
                    Chip(label: Text('Atacantes rápidos')),
                    Chip(label: Text('Meias criativos')),
                    Chip(label: Text('Defensores seguros')),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Resultados',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (playerProvider.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ...playerProvider.filteredPlayers.map((player) {
                    return Card(
                      child: ListTile(
                        onTap: () => context.push('/home/player/${player.id}'),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(player.photoUrl),
                        ),
                        title: Text(player.name),
                        subtitle:
                            Text('${player.club} • ${player.positionsDisplay}'),
                        trailing: player.isVerified
                            ? const Icon(Icons.verified, color: Colors.blue)
                            : null,
                      ),
                    );
                  }),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Resultados de posts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...postResults.map((post) {
                  return Card(
                    child: ListTile(
                      onTap: () => context.push('/home/post/${post.id}'),
                      leading: Image.network(
                        post.mediaUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      ),
                      title: Text(post.caption ?? 'Post sem legenda'),
                      subtitle: Text('${post.likes} curtidas'),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _FilterSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

String _positionLabel(PlayerPosition position) {
  switch (position) {
    case PlayerPosition.gk:
      return 'GK';
    case PlayerPosition.rb:
      return 'RB';
    case PlayerPosition.lb:
      return 'LB';
    case PlayerPosition.rcb:
      return 'RCB';
    case PlayerPosition.cb:
      return 'CB';
    case PlayerPosition.lcb:
      return 'LCB';
    case PlayerPosition.rwb:
      return 'RWB';
    case PlayerPosition.lwb:
      return 'LWB';
    case PlayerPosition.dm:
      return 'DM';
    case PlayerPosition.cm:
      return 'CM';
    case PlayerPosition.am:
      return 'AM';
    case PlayerPosition.rw:
      return 'RW';
    case PlayerPosition.lw:
      return 'LW';
    case PlayerPosition.ss:
      return 'SS';
    case PlayerPosition.st:
      return 'ST';
  }
}

String _statusLabel(PlayerStatus status) {
  switch (status) {
    case PlayerStatus.base:
      return 'Base';
    case PlayerStatus.professional:
      return 'Profissional';
    case PlayerStatus.withoutClub:
      return 'Sem clube';
    case PlayerStatus.returningFromInjury:
      return 'Retornando';
  }
}

String _footLabel(Foot foot) {
  switch (foot) {
    case Foot.right:
      return 'Direito';
    case Foot.left:
      return 'Esquerdo';
    case Foot.both:
      return 'Ambidestro';
  }
}

String _potentialLabel(Potential potential) {
  switch (potential) {
    case Potential.low:
      return 'Baixo';
    case Potential.medium:
      return 'Médio';
    case Potential.high:
      return 'Alto';
  }
}

String _riskLabel(InjuryRisk risk) {
  switch (risk) {
    case InjuryRisk.low:
      return 'Baixo';
    case InjuryRisk.medium:
      return 'Médio';
    case InjuryRisk.high:
      return 'Alto';
  }
}

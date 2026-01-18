import '../models/models.dart';
import 'mock_data_service.dart';

class PlayerRepository {
  final List<Player> _players = MockDataService.generateMockPlayers();

  Future<List<Player>> getAllPlayers() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    return _players;
  }

  Future<Player?> getPlayerById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _players.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<Player>> searchPlayers(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return _players
        .where(
          (p) =>
              p.name.toLowerCase().contains(lowerQuery) ||
              p.club.toLowerCase().contains(lowerQuery) ||
              p.league.toLowerCase().contains(lowerQuery) ||
              p.nationality.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  Future<List<Player>> filterPlayers(SearchFilters filters) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _players.where((player) {
      // Position filter
      if (filters.positions != null && filters.positions!.isNotEmpty) {
        final hasPosition = player.positions.any(
          (pos) => filters.positions!.contains(pos),
        );
        if (!hasPosition) return false;
      }

      // Foot filter
      if (filters.preferredFoot != null &&
          player.preferredFoot != filters.preferredFoot) {
        return false;
      }

      // Age range filter
      if (filters.ageMin != null && player.age < filters.ageMin!) return false;
      if (filters.ageMax != null && player.age > filters.ageMax!) return false;

      // Height range filter
      if (filters.heightMin != null && player.height < filters.heightMin!)
        return false;
      if (filters.heightMax != null && player.height > filters.heightMax!)
        return false;

      // Weight range filter
      if (filters.weightMin != null && player.weight < filters.weightMin!)
        return false;
      if (filters.weightMax != null && player.weight > filters.weightMax!)
        return false;

      // Country/League filter
      if (filters.countries != null && filters.countries!.isNotEmpty) {
        if (!filters.countries!.contains(player.country) &&
            !filters.countries!.contains(player.league)) {
          return false;
        }
      }

      // Status filter
      if (filters.statuses != null && filters.statuses!.isNotEmpty) {
        if (!filters.statuses!.contains(player.status)) return false;
      }

      // Creation filter
      if (filters.creation != null) {
        if (filters.creation == 'futly' && player.createdByUserId != null)
          return false;
        if (filters.creation == 'community' && player.createdByUserId == null)
          return false;
      }

      // Verified filter
      if (filters.isVerified != null &&
          player.isVerified != filters.isVerified) {
        return false;
      }

      // Potential filter
      if (filters.potentials != null && filters.potentials!.isNotEmpty) {
        if (!filters.potentials!.contains(player.potential)) return false;
      }

      // Market range filter
      if (filters.marketMin != null &&
          player.estimatedValueMax < filters.marketMin!)
        return false;
      if (filters.marketMax != null &&
          player.estimatedValueMin > filters.marketMax!)
        return false;

      // Style tags filter
      if (filters.styleTags != null && filters.styleTags!.isNotEmpty) {
        final hasTag = player.styleTags.any(
          (tag) => filters.styleTags!.contains(tag),
        );
        if (!hasTag) return false;
      }

      // Strengths filter
      if (filters.strengths != null && filters.strengths!.isNotEmpty) {
        final hasStrength = player.strengths.any(
          (strength) => filters.strengths!.contains(strength),
        );
        if (!hasStrength) return false;
      }

      // Weaknesses filter (inverted - exclude players with these weaknesses)
      if (filters.weaknesses != null && filters.weaknesses!.isNotEmpty) {
        final hasWeakness = player.weaknesses.any(
          (weakness) => filters.weaknesses!.contains(weakness),
        );
        if (hasWeakness) return false;
      }

      // Tactical block filter
      if (filters.block != null && player.bestBlock != filters.block) {
        return false;
      }

      // Injury risk filter
      if (filters.injuryRisk != null &&
          player.injuryRisk != filters.injuryRisk) {
        return false;
      }

      return true;
    }).toList();
  }

  Future<void> createPlayer(Player player) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _players.add(player);
  }

  Future<void> updatePlayer(Player player) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _players.indexWhere((p) => p.id == player.id);
    if (index != -1) {
      _players[index] = player;
    }
  }

  Future<void> favoritePlayer(String playerId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final playerIndex = _players.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1) {
      final player = _players[playerIndex];
      if (!player.savedByUsers.contains(userId)) {
        _players[playerIndex] = Player(
          id: player.id,
          name: player.name,
          nickname: player.nickname,
          birthYear: player.birthYear,
          age: player.age,
          nationality: player.nationality,
          city: player.city,
          languages: player.languages,
          club: player.club,
          league: player.league,
          country: player.country,
          contractStatus: player.contractStatus,
          agent: player.agent,
          status: player.status,
          positions: player.positions,
          primaryPosition: player.primaryPosition,
          height: player.height,
          weight: player.weight,
          bodyType: player.bodyType,
          preferredFoot: player.preferredFoot,
          isVerified: player.isVerified,
          createdByUserId: player.createdByUserId,
          paceAcceleration: player.paceAcceleration,
          topSpeed: player.topSpeed,
          stamina: player.stamina,
          strength: player.strength,
          agility: player.agility,
          balance: player.balance,
          jump: player.jump,
          passingShort: player.passingShort,
          passingLong: player.passingLong,
          progressivePass: player.progressivePass,
          firstTouch: player.firstTouch,
          ballControl: player.ballControl,
          dribbling: player.dribbling,
          crossing: player.crossing,
          finishing: player.finishing,
          shotPower: player.shotPower,
          heading: player.heading,
          tackling: player.tackling,
          interception: player.interception,
          positioning: player.positioning,
          aerialDuels: player.aerialDuels,
          groundDuels: player.groundDuels,
          weakFootQuality: player.weakFootQuality,
          buildUp: player.buildUp,
          pressResistance: player.pressResistance,
          decisionMaking: player.decisionMaking,
          scanning: player.scanning,
          offBallMovement: player.offBallMovement,
          defensiveLine: player.defensiveLine,
          pressing: player.pressing,
          recoveryRuns: player.recoveryRuns,
          composure: player.composure,
          aggression: player.aggression,
          leadership: player.leadership,
          teamwork: player.teamwork,
          resilience: player.resilience,
          coachability: player.coachability,
          professionalism: player.professionalism,
          gameIQ: player.gameIQ,
          riskTaking: player.riskTaking,
          discipline: player.discipline,
          styleTags: player.styleTags,
          roles: player.roles,
          strengths: player.strengths,
          weaknesses: player.weaknesses,
          bestSystems: player.bestSystems,
          bestBlock: player.bestBlock,
          description: player.description,
          estimatedValueMin: player.estimatedValueMin,
          estimatedValueMax: player.estimatedValueMax,
          salaryMin: player.salaryMin,
          salaryMax: player.salaryMax,
          potential: player.potential,
          transferRisk: player.transferRisk,
          isReadyToLevelUp: player.isReadyToLevelUp,
          injuryHistory: player.injuryHistory,
          injuryRisk: player.injuryRisk,
          photoUrl: player.photoUrl,
          highlightVideos: player.highlightVideos,
          createdAt: player.createdAt,
          updatedAt: player.updatedAt,
          followers: player.followers,
          savedByUsers: [...player.savedByUsers, userId],
        );
      }
    }
  }

  Future<void> unfavoritePlayer(String playerId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final playerIndex = _players.indexWhere((p) => p.id == playerId);
    if (playerIndex != -1) {
      final player = _players[playerIndex];
      _players[playerIndex] = Player(
        id: player.id,
        name: player.name,
        nickname: player.nickname,
        birthYear: player.birthYear,
        age: player.age,
        nationality: player.nationality,
        city: player.city,
        languages: player.languages,
        club: player.club,
        league: player.league,
        country: player.country,
        contractStatus: player.contractStatus,
        agent: player.agent,
        status: player.status,
        positions: player.positions,
        primaryPosition: player.primaryPosition,
        height: player.height,
        weight: player.weight,
        bodyType: player.bodyType,
        preferredFoot: player.preferredFoot,
        isVerified: player.isVerified,
        createdByUserId: player.createdByUserId,
        paceAcceleration: player.paceAcceleration,
        topSpeed: player.topSpeed,
        stamina: player.stamina,
        strength: player.strength,
        agility: player.agility,
        balance: player.balance,
        jump: player.jump,
        passingShort: player.passingShort,
        passingLong: player.passingLong,
        progressivePass: player.progressivePass,
        firstTouch: player.firstTouch,
        ballControl: player.ballControl,
        dribbling: player.dribbling,
        crossing: player.crossing,
        finishing: player.finishing,
        shotPower: player.shotPower,
        heading: player.heading,
        tackling: player.tackling,
        interception: player.interception,
        positioning: player.positioning,
        aerialDuels: player.aerialDuels,
        groundDuels: player.groundDuels,
        weakFootQuality: player.weakFootQuality,
        buildUp: player.buildUp,
        pressResistance: player.pressResistance,
        decisionMaking: player.decisionMaking,
        scanning: player.scanning,
        offBallMovement: player.offBallMovement,
        defensiveLine: player.defensiveLine,
        pressing: player.pressing,
        recoveryRuns: player.recoveryRuns,
        composure: player.composure,
        aggression: player.aggression,
        leadership: player.leadership,
        teamwork: player.teamwork,
        resilience: player.resilience,
        coachability: player.coachability,
        professionalism: player.professionalism,
        gameIQ: player.gameIQ,
        riskTaking: player.riskTaking,
        discipline: player.discipline,
        styleTags: player.styleTags,
        roles: player.roles,
        strengths: player.strengths,
        weaknesses: player.weaknesses,
        bestSystems: player.bestSystems,
        bestBlock: player.bestBlock,
        description: player.description,
        estimatedValueMin: player.estimatedValueMin,
        estimatedValueMax: player.estimatedValueMax,
        salaryMin: player.salaryMin,
        salaryMax: player.salaryMax,
        potential: player.potential,
        transferRisk: player.transferRisk,
        isReadyToLevelUp: player.isReadyToLevelUp,
        injuryHistory: player.injuryHistory,
        injuryRisk: player.injuryRisk,
        photoUrl: player.photoUrl,
        highlightVideos: player.highlightVideos,
        createdAt: player.createdAt,
        updatedAt: player.updatedAt,
        followers: player.followers,
        savedByUsers: player.savedByUsers.where((id) => id != userId).toList(),
      );
    }
  }

  Future<List<Player>> getTrendingPlayers() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _players.take(10).toList();
  }

  Future<List<Player>> getFavoritePlayers(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _players.where((p) => p.savedByUsers.contains(userId)).toList();
  }
}

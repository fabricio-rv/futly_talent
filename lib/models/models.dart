// Models for Futly Talent App

// ENUMS
enum PlayerPosition {
  gk, // Goleiro
  rb, // Lateral direito
  lb, // Lateral esquerdo
  rcb, // Zagueiro centro-direita
  cb, // Zagueiro
  lcb, // Zagueiro centro-esquerda
  rwb, // Ala direito
  lwb, // Ala esquerdo
  dm, // Volante
  cm, // Meia central
  am, // Meia ofensivo
  rw, // Ponta direita
  lw, // Ponta esquerda
  ss, // Segundo atacante
  st, // Centroavante
}

enum PlayerStatus {
  base, // Base
  professional, // Profissional
  withoutClub, // Sem clube
  returningFromInjury, // Retornando de lesão
}

enum ContractStatus {
  noInfo, // Sem informação
  short, // Curto
  medium, // Médio
  long, // Longo
}

enum BodyType {
  lean, // Magro
  athletic, // Atlético
  muscular, // Musculoso
  heavy, // Robusto
}

enum Foot {
  right, // Direito
  left, // Esquerdo
  both, // Ambidestro
}

enum TacticalBlock {
  high, // Alto
  medium, // Médio
  low, // Baixo
}

enum Potential {
  low, // Baixo
  medium, // Médio
  high, // Alto
}

enum TransferRisk {
  low, // Baixo
  medium, // Médio
  high, // Alto
}

enum InjuryRisk {
  low, // Baixo
  medium, // Médio
  high, // Alto
}

// MODELS
class Player {
  final String id;
  final String name;
  final String? nickname;
  final int birthYear;
  final int age;
  final String nationality;
  final String? city;
  final String? languages;
  final String club;
  final String league;
  final String country;
  final ContractStatus contractStatus;
  final String? agent;
  final PlayerStatus status;
  final List<PlayerPosition> positions;
  final PlayerPosition primaryPosition;
  final double height; // cm
  final double weight; // kg
  final BodyType bodyType;
  final Foot preferredFoot;
  final bool isVerified;
  final String? createdByUserId;

  // Physical attributes (0-100)
  final int paceAcceleration;
  final int topSpeed;
  final int stamina;
  final int strength;
  final int agility;
  final int balance;
  final int jump;

  // Technical attributes (0-100)
  final int passingShort;
  final int passingLong;
  final int progressivePass;
  final int firstTouch;
  final int ballControl;
  final int dribbling;
  final int crossing;
  final int finishing;
  final int shotPower;
  final int heading;
  final int tackling;
  final int interception;
  final int positioning;
  final int aerialDuels;
  final int groundDuels;
  final int weakFootQuality;

  // Tactical attributes (0-100)
  final int buildUp;
  final int pressResistance;
  final int decisionMaking;
  final int scanning;
  final int offBallMovement;
  final int defensiveLine;
  final int pressing;
  final int recoveryRuns;

  // Mental attributes (0-100)
  final int composure;
  final int aggression;
  final int leadership;
  final int teamwork;
  final int resilience;
  final int coachability;
  final int professionalism;
  final int gameIQ;
  final int riskTaking;
  final int discipline;

  // Qualitative data
  final List<String> styleTags;
  final List<String> roles;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> bestSystems;
  final TacticalBlock bestBlock;
  final String description;

  // Market
  final int estimatedValueMin; // EUR
  final int estimatedValueMax; // EUR
  final int? salaryMin; // EUR per month
  final int? salaryMax; // EUR per month
  final Potential potential;
  final TransferRisk transferRisk;
  final bool isReadyToLevelUp;

  // Health
  final List<InjuryHistory> injuryHistory;
  final InjuryRisk injuryRisk;

  // Media
  final String photoUrl;
  final List<String> highlightVideos;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;
  final int followers;
  final List<String> savedByUsers;

  Player({
    required this.id,
    required this.name,
    this.nickname,
    required this.birthYear,
    required this.age,
    required this.nationality,
    this.city,
    this.languages,
    required this.club,
    required this.league,
    required this.country,
    required this.contractStatus,
    this.agent,
    required this.status,
    required this.positions,
    required this.primaryPosition,
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.preferredFoot,
    required this.isVerified,
    this.createdByUserId,
    required this.paceAcceleration,
    required this.topSpeed,
    required this.stamina,
    required this.strength,
    required this.agility,
    required this.balance,
    required this.jump,
    required this.passingShort,
    required this.passingLong,
    required this.progressivePass,
    required this.firstTouch,
    required this.ballControl,
    required this.dribbling,
    required this.crossing,
    required this.finishing,
    required this.shotPower,
    required this.heading,
    required this.tackling,
    required this.interception,
    required this.positioning,
    required this.aerialDuels,
    required this.groundDuels,
    required this.weakFootQuality,
    required this.buildUp,
    required this.pressResistance,
    required this.decisionMaking,
    required this.scanning,
    required this.offBallMovement,
    required this.defensiveLine,
    required this.pressing,
    required this.recoveryRuns,
    required this.composure,
    required this.aggression,
    required this.leadership,
    required this.teamwork,
    required this.resilience,
    required this.coachability,
    required this.professionalism,
    required this.gameIQ,
    required this.riskTaking,
    required this.discipline,
    required this.styleTags,
    required this.roles,
    required this.strengths,
    required this.weaknesses,
    required this.bestSystems,
    required this.bestBlock,
    required this.description,
    required this.estimatedValueMin,
    required this.estimatedValueMax,
    this.salaryMin,
    this.salaryMax,
    required this.potential,
    required this.transferRisk,
    required this.isReadyToLevelUp,
    required this.injuryHistory,
    required this.injuryRisk,
    required this.photoUrl,
    required this.highlightVideos,
    required this.createdAt,
    required this.updatedAt,
    required this.followers,
    required this.savedByUsers,
  });

  bool isFavoritedBy(String userId) => savedByUsers.contains(userId);

  String get positionsDisplay =>
      positions.map((p) => _positionToString(p)).join(', ');

  String _positionToString(PlayerPosition pos) {
    switch (pos) {
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
}

class InjuryHistory {
  final int year;
  final String type;
  final int monthsOut;
  final InjuryRisk recurrenceRisk;

  InjuryHistory({
    required this.year,
    required this.type,
    required this.monthsOut,
    required this.recurrenceRisk,
  });
}

class Post {
  final String id;
  final String authorId;
  final String? linkedPlayerId;
  final String mediaType; // 'video' or 'photo'
  final String mediaUrl;
  final String? caption;
  final List<String> tags;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int reposts;
  final List<String> likedByUsers;
  final List<String> savedByUsers;
  final List<String> repostedByUsers;

  Post({
    required this.id,
    required this.authorId,
    this.linkedPlayerId,
    required this.mediaType,
    required this.mediaUrl,
    this.caption,
    required this.tags,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.likedByUsers,
    required this.savedByUsers,
    required this.repostedByUsers,
  });

  bool isLikedBy(String userId) => likedByUsers.contains(userId);
  bool isSavedBy(String userId) => savedByUsers.contains(userId);
  bool isRepostedBy(String userId) => repostedByUsers.contains(userId);
}

class Comment {
  final String id;
  final String postId;
  final String authorId;
  final String text;
  final DateTime createdAt;
  final int likes;
  final List<String> likedByUsers;

  Comment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.text,
    required this.createdAt,
    required this.likes,
    required this.likedByUsers,
  });

  bool isLikedBy(String userId) => likedByUsers.contains(userId);
}

class User {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final String avatarUrl;
  final bool isVerified;
  final DateTime createdAt;
  final int postsCount;
  final int playersCreatedCount;
  final int savesCount;
  final List<String> followers;
  final List<String> following;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    required this.avatarUrl,
    required this.isVerified,
    required this.createdAt,
    required this.postsCount,
    required this.playersCreatedCount,
    required this.savesCount,
    required this.followers,
    required this.following,
  });
}

class Message {
  final String id;
  final String senderId;
  final String conversationId;
  final String text;
  final DateTime timestamp;
  final String? sharedPostId;
  final String? sharedPlayerId;

  Message({
    required this.id,
    required this.senderId,
    required this.conversationId,
    required this.text,
    required this.timestamp,
    this.sharedPostId,
    this.sharedPlayerId,
  });
}

class Conversation {
  final String id;
  final String userId;
  final String participantId;
  final List<Message> messages;
  final DateTime lastMessageTime;

  Conversation({
    required this.id,
    required this.userId,
    required this.participantId,
    required this.messages,
    required this.lastMessageTime,
  });
}

class Notification {
  final String id;
  final String userId;
  final String type; // 'like', 'comment', 'follow', 'approval'
  final String title;
  final String? description;
  final String? linkedEntityId;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.description,
    this.linkedEntityId,
    required this.timestamp,
    required this.isRead,
  });
}

class PlayerSuggestion {
  final String id;
  final String suggestedByUserId;
  final String name;
  final PlayerPosition position;
  final String club;
  final String country;
  final String reason;
  final List<String> suggestedTags;
  final List<String> suggestedStrengths;
  final List<String> suggestedWeaknesses;
  final int estimatedValueMin;
  final int estimatedValueMax;
  final DateTime createdAt;
  final String status; // 'pending', 'approved', 'rejected'

  PlayerSuggestion({
    required this.id,
    required this.suggestedByUserId,
    required this.name,
    required this.position,
    required this.club,
    required this.country,
    required this.reason,
    required this.suggestedTags,
    required this.suggestedStrengths,
    required this.suggestedWeaknesses,
    required this.estimatedValueMin,
    required this.estimatedValueMax,
    required this.createdAt,
    required this.status,
  });
}

class SearchFilters {
  final List<PlayerPosition>? positions;
  final Foot? preferredFoot;
  final int? ageMin;
  final int? ageMax;
  final double? heightMin;
  final double? heightMax;
  final double? weightMin;
  final double? weightMax;
  final List<String>? countries;
  final List<String>? leagues;
  final List<PlayerStatus>? statuses;
  final String? creation; // 'futly' or 'community'
  final bool? isVerified;
  final List<Potential>? potentials;
  final int? marketMin;
  final int? marketMax;
  final List<String>? styleTags;
  final List<String>? strengths;
  final List<String>? weaknesses;
  final TacticalBlock? block;
  final String? tacticalSystem;
  final InjuryRisk? injuryRisk;

  SearchFilters({
    this.positions,
    this.preferredFoot,
    this.ageMin,
    this.ageMax,
    this.heightMin,
    this.heightMax,
    this.weightMin,
    this.weightMax,
    this.countries,
    this.leagues,
    this.statuses,
    this.creation,
    this.isVerified,
    this.potentials,
    this.marketMin,
    this.marketMax,
    this.styleTags,
    this.strengths,
    this.weaknesses,
    this.block,
    this.tacticalSystem,
    this.injuryRisk,
  });

  SearchFilters copyWith({
    List<PlayerPosition>? positions,
    Foot? preferredFoot,
    int? ageMin,
    int? ageMax,
    double? heightMin,
    double? heightMax,
    double? weightMin,
    double? weightMax,
    List<String>? countries,
    List<String>? leagues,
    List<PlayerStatus>? statuses,
    String? creation,
    bool? isVerified,
    List<Potential>? potentials,
    int? marketMin,
    int? marketMax,
    List<String>? styleTags,
    List<String>? strengths,
    List<String>? weaknesses,
    TacticalBlock? block,
    String? tacticalSystem,
    InjuryRisk? injuryRisk,
  }) {
    return SearchFilters(
      positions: positions ?? this.positions,
      preferredFoot: preferredFoot ?? this.preferredFoot,
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      heightMin: heightMin ?? this.heightMin,
      heightMax: heightMax ?? this.heightMax,
      weightMin: weightMin ?? this.weightMin,
      weightMax: weightMax ?? this.weightMax,
      countries: countries ?? this.countries,
      leagues: leagues ?? this.leagues,
      statuses: statuses ?? this.statuses,
      creation: creation ?? this.creation,
      isVerified: isVerified ?? this.isVerified,
      potentials: potentials ?? this.potentials,
      marketMin: marketMin ?? this.marketMin,
      marketMax: marketMax ?? this.marketMax,
      styleTags: styleTags ?? this.styleTags,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      block: block ?? this.block,
      tacticalSystem: tacticalSystem ?? this.tacticalSystem,
      injuryRisk: injuryRisk ?? this.injuryRisk,
    );
  }
}

class Comparison {
  final String id;
  final String player1Id;
  final String player2Id;
  final DateTime createdAt;

  Comparison({
    required this.id,
    required this.player1Id,
    required this.player2Id,
    required this.createdAt,
  });
}

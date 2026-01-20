
class PortfolioData {
  // Personal Details
  static const String name = "Abdul Basith";
  static const String title = "Flutter Developer";
  static const String email = "abbasith222@gmail.com";
  static const String location = "Hawalli, Kuwait";
  static const String aboutShort = "I build apps that feel fast and beautiful.";
  static const String aboutLong =
      "I am a passionate Flutter developer with a knack for creating beautiful, responsive, and performant mobile and web applications. With a strong foundation in Dart and a keen eye for design, I transform ideas into seamless digital experiences.";

  // Social Links
  static const String githubUrl = "https://github.com/Basith2858";
  static const String linkedinUrl =
      "https://www.linkedin.com/in/abdul-basith200";
  static const String resumeUrl = ""; // Add URL if available

  // Profile Image (Asset path)
  static const String profileImage = "assets/images/profile.jpg"; // Placeholder

  // Statistics
  static const List<StatItem> stats = [
    StatItem(count: "3+", label: "Years Exp"),
    StatItem(count: "10+", label: "Apps Built"),
    StatItem(count: "100%", label: "Satisfaction"),
  ];

  // Skills
  static const List<SkillCategory> skillCategories = [
    SkillCategory(
      title: "Flutter & Dart",
      skills: ["Flutter", "Dart", "Widget Lifecycle", "Performance Profiling"],
    ),
    SkillCategory(
      title: "State Management",
      skills: ["Riverpod", "Provider", "BLoC"],
    ),
    SkillCategory(
      title: "Backend & API",
      skills: ["Firebase", "REST APIs", "Cloud Functions", "Supabase"],
    ),
    SkillCategory(
      title: "Tools & UI",
      skills: ["Git", "Figma", "Adobe XD", "CI/CD"],
    ),
  ];

  // Experience
  static const List<TimelineItem> experience = [
    TimelineItem(
      title: "Senior Flutter Developer",
      subtitle: "Tech Company Inc.",
      period: "2023 - Present",
      description:
          "Leading the mobile team, architecting scalable apps, and mentoring juniors.",
    ),
    TimelineItem(
      title: "Flutter Developer",
      subtitle: "Software Solutions LLC",
      period: "2021 - 2023",
      description:
          "Developed and maintained multiple client applications. Integrated complex APIs.",
    ),
    TimelineItem(
      title: "BSc Computer Science",
      subtitle: "University of Tech",
      period: "2017 - 2021",
      description:
          "Graduated with honors. Focused on Mobile Computing and Algorithms.",
    ),
  ];

  // Projects
  static const List<Project> projects = [
    Project(
      id: "finance-app",
      title: "Finance Tracker",
      description:
          "A comprehensive personal finance management app with chart visualizations and expense tracking.",
      tags: ["Flutter", "Riverpod", "Firebase"],
      imageUrl: "assets/images/project1.jpg",
      githubUrl: "https://github.com/example/finance",
      liveUrl:
          "https://play.google.com/store/apps/details?id=com.example.finance",
      screenshots: ["assets/images/p1_1.jpg", "assets/images/p1_2.jpg"],
    ),
    Project(
      id: "e-commerce",
      title: "ShopEasy",
      description:
          "A multi-vendor e-commerce platform with real-time order tracking and payment gateway integration.",
      tags: ["Flutter", "Clean Arch", "Stripe"],
      imageUrl: "assets/images/project2.jpg",
      githubUrl: "https://github.com/example/shopeasy",
    ),
    Project(
      id: "social-connect",
      title: "SocialConnect",
      description:
          "A social media app for professionals to connect and share insights.",
      tags: ["Flutter", "GetX", "Socket.io"],
      imageUrl: "assets/images/project3.jpg",
      liveUrl: "https://apps.apple.com/app/id123456",
    ),
    Project(
      id: "travel-buddy",
      title: "TravelBuddy",
      description:
          "Travel planning assistance with itinerary generation and map integration.",
      tags: ["Flutter", "Google Maps API", "AI"],
      imageUrl: "assets/images/project4.jpg",
    ),
  ];
}

// Models
class StatItem {
  final String count;
  final String label;

  const StatItem({required this.count, required this.label});
}

class SkillCategory {
  final String title;
  final List<String> skills;

  const SkillCategory({required this.title, required this.skills});
}

class TimelineItem {
  final String title;
  final String subtitle;
  final String period;
  final String description;

  const TimelineItem({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
  });
}

class Project {
  final String id;
  final String title;
  final String description;
  final List<String> tags;
  final String imageUrl;
  final String? githubUrl;
  final String? liveUrl;
  final List<String> screenshots;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.tags,
    required this.imageUrl,
    this.githubUrl,
    this.liveUrl,
    this.screenshots = const [],
  });
}

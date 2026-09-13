import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question.dart';

/// Question service responsible for offline question loading, UTF-8 parsing, and shuffling
class QuestionService {
  static List<Question> _cachedQuestions = [];

  /// Fallback questions embedded directly in code to guarantee 100% offline availability
  static const List<Map<String, dynamic>> _fallbackQuestions = [
    {
      "id": 101,
      "category": "أندية مشتركة",
      "question": "اذكر 3 لاعبين ارتدوا قميص ريال مدريد وبرشلونة عبر التاريخ",
      "answers": [
        "رونالدو الظاهرة (Ronaldo Nazário)",
        "لويس فيجو (Luís Figo)",
        "لويس إنريكي (Luis Enrique)"
      ],
      "hint": "من أشهرهم أيضاً: صامويل إيتو، خافيير سافيولا، مايكل لاودروب، وجورجي هاجي",
      "difficulty": "سهل"
    },
    {
      "id": 102,
      "category": "أندية مشتركة",
      "question": "اذكر 3 لاعبين ارتدوا قميص الأهلي والزمالك في مصر",
      "answers": ["حسام حسن", "إبراهيم حسن", "إمام عاشور"],
      "hint": "خيارات أخرى: كهربا، مؤمن زكريا، طارق السعيد، عصام الحضري، رضا عبد العال",
      "difficulty": "سهل"
    },
    {
      "id": 103,
      "category": "هدافين وأساطير",
      "question": "اذكر 3 لاعبين فازوا بجائزة الكرة الذهبية (Ballon d'Or) أكثر من مرة",
      "answers": [
        "ليونيل ميسي (8 مرات)",
        "كريستيانو رونالدو (5 مرات)",
        "ميشيل بلاتيني (3 مرات)"
      ],
      "hint": "أيضاً: يوهان كرويف (3)، ماركو فان باستن (3)، فرانتس بيكنباور (2)، رونالدو الظاهرة (2)",
      "difficulty": "متوسط"
    },
    {
      "id": 104,
      "category": "دوري أبطال أوروبا",
      "question": "اذكر 3 أندية فازت بلقب دوري أبطال أوروبا 5 مرات أو أكثر",
      "answers": [
        "ريال مدريد (15 لقب)",
        "إيه سي ميلان (7 ألقاب)",
        "ليفربول (6 ألقاب)"
      ],
      "hint": "أندية أخرى: بايرن ميونخ (6 ألقاب)، برشلونة (5 ألقاب)",
      "difficulty": "سهل"
    },
    {
      "id": 105,
      "category": "كأس العالم",
      "question": "اذكر 3 منتخبات فازت ببطولة كأس العالم مرتين أو أكثر",
      "answers": [
        "البرازيل (5 ألقاب)",
        "ألمانيا (4 ألقاب)",
        "إيطاليا (4 ألقاب)"
      ],
      "hint": "أيضاً: الأرجنتين (3 ألقاب)، فرنسا (لقبان)، أوروغواي (لقبان)",
      "difficulty": "سهل"
    },
    {
      "id": 106,
      "category": "أندية مشتركة",
      "question": "اذكر 3 لاعبين مثلوا أندية ميلان، إنتر ميلان، ويوفنتوس (الثلاثة الكبار بإيطاليا)",
      "answers": [
        "زلاتان إبراهيموفيتش",
        "أندريا بيرلو",
        "روبيرتو باجيو"
      ],
      "hint": "أيضاً: ليوناردو بونوتشي، باتريك فييرا، كريستيان فييري، إدغار دافيدز",
      "difficulty": "صعب"
    },
    {
      "id": 107,
      "category": "أرقام وجوائز",
      "question": "اذكر 3 لاعبين فازوا بجائزة الحذاء الذهبي الأوروبي",
      "answers": [
        "ليونيل ميسي",
        "كريستيانو رونالدو",
        "روبرت ليفاندوفسكي"
      ],
      "hint": "أيضاً: إرلينغ هالاند، لويس سواريز، هاري كين، دييجو فورلان، تييري هنري",
      "difficulty": "سهل"
    },
    {
      "id": 108,
      "category": "الكرة المصرية",
      "question": "اذكر 3 هدافين تاريخيين لمنتخب مصر الأول",
      "answers": [
        "حسام حسن (68 هدفاً)",
        "محمد صلاح (أكثر من 55 هدفاً)",
        "حسن الشاذلي (42 هدفاً)"
      ],
      "hint": "أيضاً: محمد أبو تريكة (38 هدفاً)، أحمد حسن (33 هدفاً)",
      "difficulty": "متوسط"
    },
    {
      "id": 109,
      "category": "مدربون وإنجازات",
      "question": "اذكر 3 مدربين حققوا لقب دوري أبطال أوروبا 3 مرات أو أكثر",
      "answers": [
        "كارلو أنشيلوتي (5 ألقاب)",
        "بيب غوارديولا (3 ألقاب)",
        "زين الدين زيدان (3 ألقاب)"
      ],
      "hint": "أيضاً: بوب بيزلي (3 ألقاب مع ليفربول)",
      "difficulty": "متوسط"
    },
    {
      "id": 110,
      "category": "أندية مشتركة",
      "question": "اذكر 3 لاعبين ارتدوا قميص مانشستر يونايتد وريال مدريد",
      "answers": [
        "كريستيانو رونالدو",
        "ديفيد بيكهام",
        "رود فان نيستلروي"
      ],
      "hint": "أيضاً: كاسيميرو، رافاييل فاران، أنخيل دي ماريا، مايكل أوين، خافيير هيرنانديز (تشيتشاريتو)",
      "difficulty": "سهل"
    },
    {
      "id": 111,
      "category": "أساطير المونديال",
      "question": "اذكر 3 لاعبين سجلوا في نهائي كأس العالم لكرة القدم",
      "answers": [
        "كيليان مبابي (نهائي 2018 و 2022)",
        "ليونيل ميسي (نهائي 2022)",
        "زين الدين زيدان (نهائي 1998 و 2006)"
      ],
      "hint": "أيضاً: رونالدو الظاهرة (2002)، بيليه (1958 و 1970)، ماريو غوتزه (2014)، أندريس إنييستا (2010)",
      "difficulty": "سهل"
    },
    {
      "id": 112,
      "category": "ديربيات وأندية",
      "question": "اذكر 3 لاعبين لعبوا لمانشستر يونايتد ومانشستر سيتي",
      "answers": [
        "كارلوس تيفيز",
        "بيتر شمايكل",
        "آندي كول"
      ],
      "hint": "أيضاً: أوين هارغريفز، دينيس لو، جادون سانشو",
      "difficulty": "متوسط"
    },
    {
      "id": 113,
      "category": "الكرة الإفريقية",
      "question": "اذكر 3 منتخبات عربية فازت بلقب كأس أمم إفريقيا",
      "answers": [
        "منتخب مصر (7 ألقاب)",
        "منتخب الجزائر (لقبان)",
        "منتخب تونس (لقب 2004)"
      ],
      "hint": "أيضاً: منتخب المغرب (1976)، منتخب السودان (1970)",
      "difficulty": "سهل"
    },
    {
      "id": 114,
      "category": "أندية وبطولات",
      "question": "اذكر 3 لاعبين فازوا بلقب كأس العالم ودوري أبطال أوروبا والكرة الذهبية",
      "answers": [
        "ليونيل ميسي",
        "زين الدين زيدان",
        "رونالدينيو"
      ],
      "hint": "أيضاً: رونالدو الظاهرة، ريفالدو، كاكا، بوبي تشارلتون، فرانتس بيكنباور، غيرد مولر",
      "difficulty": "متوسط"
    },
    {
      "id": 115,
      "category": "الدوري الإنجليزي",
      "question": "اذكر 3 لاعبين سجلوا أكثر من 200 هدف في تاريخ الدوري الإنجليزي الممتاز",
      "answers": [
        "آلان شيرر (260 هدفاً)",
        "هاري كين (213 هدفاً)",
        "واين روني (208 أهداف)"
      ],
      "hint": "الوحيدون الذين تخطوا حاجز 200 هدف، بينما يليهم أندي كول (187) وسيرجيو أجويرو (184)",
      "difficulty": "صعب"
    },
    {
      "id": 116,
      "category": "أندية مشتركة",
      "question": "اذكر 3 لاعبين مثلوا نادي أرسنال وتشيلسي في لندن",
      "answers": [
        "بيتر تشيك",
        "سيسك فابريجاس",
        "أوليفييه جيرو"
      ],
      "hint": "أيضاً: كاي هافيرتز، رحيم ستيرلينغ، ويليان، نيكولاس أنيلكا، ديفيد لويز، آشلي كول",
      "difficulty": "سهل"
    },
    {
      "id": 117,
      "category": "حراس مرمى",
      "question": "اذكر 3 حراس مرمى فازوا بجائزة ياشين أو جائزة أفضل حارس في العالم من فيفا",
      "answers": [
        "تيبو كورتوا",
        "إيميليانو مارتينيز",
        "مانويل نوير"
      ],
      "hint": "أيضاً: جانلويجي دوناروما، أليسون بيكر، جانلويجي بوفون، إيكر كاسياس",
      "difficulty": "متوسط"
    },
    {
      "id": 118,
      "category": "الدوري الإسباني",
      "question": "اذكر 3 لاعبين ارتدوا قميص أتلتيكو مدريد وبرشلونة",
      "answers": [
        "لويس سواريز",
        "أنطوان غريزمان",
        "دافيد فيا"
      ],
      "hint": "أيضاً: ممفيس ديباي، أردا توران، سيرجي روبيرتو، بيرند شوستر",
      "difficulty": "متوسط"
    },
    {
      "id": 119,
      "category": "الكرة الآسيوية والعربية",
      "question": "اذكر 3 أندية سعودية توجت بلقب دوري أبطال آسيا أو بلغت النهائي",
      "answers": [
        "نادي الهلال (4 ألقاب)",
        "نادي الاتحاد (لقبان)",
        "نادي الأهلي (وصيف مرتين)"
      ],
      "hint": "الأندية التي حققت اللقب رسمياً هي الهلال والاتحاد",
      "difficulty": "متوسط"
    },
    {
      "id": 120,
      "category": "كأس العالم للأندية",
      "question": "اذكر 3 أندية مختلفة فازت بلقب كأس العالم للأندية",
      "answers": [
        "ريال مدريد (5 ألقاب)",
        "برشلونة (3 ألقاب)",
        "بايرن ميونخ (لقبان)"
      ],
      "hint": "أندية أخرى: تشيلسي، ليفربول، مانشستر سيتي، إنتر ميلان، ميلان، كورينثيانز",
      "difficulty": "سهل"
    }
  ];

  /// Loads questions from assets/data/questions.json with explicit UTF-8 decoding
  static Future<List<Question>> loadQuestions() async {
    if (_cachedQuestions.isNotEmpty) {
      return List<Question>.from(_cachedQuestions);
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/questions.json',
        cache: false,
      );
      
      // Ensure proper UTF-8 handling
      final dynamic decoded = jsonDecode(jsonString);
      if (decoded is Map<String, dynamic> && decoded.containsKey('questions')) {
        final list = (decoded['questions'] as List<dynamic>)
            .map((item) => Question.fromJson(item as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) {
          _cachedQuestions = list;
          return List<Question>.from(_cachedQuestions);
        }
      }
    } catch (e) {
      // Fallback gracefully to built-in questions
    }

    // Fallback if asset loading fails or in mock test environment
    _cachedQuestions = _fallbackQuestions
        .map((item) => Question.fromJson(item))
        .toList();
    return List<Question>.from(_cachedQuestions);
  }

  /// Prepare a randomized queue of questions for a session
  static Future<List<Question>> getShuffledQuestions({int count = 20}) async {
    final allQuestions = await loadQuestions();
    final shuffled = List<Question>.from(allQuestions)..shuffle();
    
    if (shuffled.length >= count) {
      return shuffled.sublist(0, count);
    }
    
    // If more questions needed than available, repeat shuffled list
    final List<Question> result = [];
    while (result.length < count) {
      final batch = List<Question>.from(allQuestions)..shuffle();
      result.addAll(batch);
    }
    return result.sublist(0, count);
  }
}

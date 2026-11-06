import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Note {
  Note({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
    this.isFavorite = false,
    this.isArchived = false,
  });

  String title;
  String description;
  String date;
  Color color;
  bool isFavorite;
  bool isArchived;
}

class NotesScreen extends StatefulWidget {
  final bool isDarkMode;
  final Future<void> Function() onThemeToggle;

  const NotesScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = 'Barchasi';
  int selectedBottomIndex = 0;
  



  final List<Note> notes = [
    Note(
      title: 'Bugungi rejalar',
      description: '1. Dars o‘qish\n'
          '2. Sport\n'
          '3. Loyihani yakunlash',
      date: 'Bugun, 10:30',
      color: const Color(0xFFF1E8FF),
      isFavorite: false,
    ),
    Note(
      title: 'Flutter o‘rganish',
      description: 'Stateless va Stateful widgetlar...',
      date: 'Kecha, 18:45',
      color: const Color(0xFFF1E8FF),
    ),
    Note(
      title: 'Xaridlar ro‘yxati',
      description: 'Sut, non, mevalar, qog‘oz...',
      date: '12 mart, 09:15',
      color: const Color(0xFFE1F8E9),
    ),
    Note(
      title: 'G‘oyalar',
      description: 'Yangi loyiha uchun g‘oyalar:\n'
          '- Qaydlar\n'
          '- Vazifalar...',
      date: '10 mart, 14:20',
      color: const Color(0xFFFFEBD8),
    ),
  ];

  List<Note> get filteredNotes {
    final query = searchController.text.toLowerCase().trim();

    return notes.where((note) {
      final matchesSearch =
          note.title.toLowerCase().contains(query) ||
          note.description.toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'Barchasi'
              ? !note.isArchived
              : selectedFilter == 'Sevimlilar'
                  ? note.isFavorite && !note.isArchived
                  : note.isArchived;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void toggleFavorite(Note note) {
    setState(() {
      note.isFavorite = !note.isFavorite;
    });
  }

  void toggleArchive(Note note) {
    setState(() {
      note.isArchived = !note.isArchived;
    });
  }

  void showAddNoteDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Yangi qayd'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Qayd sarlavhasi',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Qayd matni',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Bekor qilish'),
            ),
            FilledButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description =
                    descriptionController.text.trim();

                if (title.isEmpty) return;

                setState(() {
                  notes.insert(
                    0,
                    Note(
                      title: title,
                      description: description,
                      date: 'Hozir',
                      color: const Color(0xFFE8E9FF),
                    ),
                  );

                  selectedFilter = 'Barchasi';
                  searchController.clear();
                });

                Navigator.pop(dialogContext);
              },
              child: const Text('Saqlash'),
            ),
          ],
        );
      },
    ).then((_) {
      titleController.dispose();
      descriptionController.dispose();
    });
  }
  @override
  Widget build(BuildContext context) {
    final visibleNotes = filteredNotes;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FC),
        title: const Text(
          'MiniNotes',
          style: TextStyle(
            color: Color(0xFF5945F5),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Bildirishnomalar hozircha yo‘q'),
                ),
              );
            },
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
      tooltip: widget.isDarkMode ? 'Light Mode'
          : 'Dark Mode',
      onPressed: () {
        widget.onThemeToggle();
      },
      icon: Icon(
        widget.isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode,
      ),
    ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // 1. Qidiruv maydoni
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: TextField(
                controller: searchController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Qaydlarni qidirish...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xFFEFEFF5),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 2. Filter tugmalari
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  _buildFilter('Barchasi'),
                  _buildFilter('Sevimlilar'),
                  _buildFilter('Arxiv'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 3. Qaydlar ro‘yxati
            Expanded(
              child: visibleNotes.isEmpty
                  ? const Center(
                      child: Text('Qaydlar topilmadi'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                          16, 4, 16, 16),
                      itemCount: visibleNotes.length,
                      itemBuilder: (context, index) {
                        final note = visibleNotes[index];

                        return _buildNoteCard(note);
                      },
                    ),
            ),
          ],
        ),
      ),
// 4. Yangi qayd qo‘shish
      floatingActionButton: FloatingActionButton(
        onPressed: showAddNoteDialog,
        backgroundColor: const Color(0xFF6849F5),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 30),
      ),

      // 5. Pastki navigatsiya
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedBottomIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedBottomIndex = index;
          });

          if (index != 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${[
                    'Qaydlar',
                    'Kalendar',
                    'Statistika',
                    'Sozlamalar'
                  ][index]} oynasi keyin qo‘shiladi',
                ),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.sticky_note_2_outlined),
            selectedIcon: Icon(Icons.sticky_note_2),
            label: 'Qaydlar',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Kalendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Statistika',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Sozlamalar',
          ),
        ],
      ),
    );
  }

  // Filter tugmasining ko‘rinishi
  Widget _buildFilter(String filter) {
    final isSelected = selectedFilter == filter;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(filter),
        selected: isSelected,
        showCheckmark: false,
        onSelected: (_) {
          setState(() {
            selectedFilter = filter;
          });
        },
        selectedColor: const Color(0xFF6849F5),
        backgroundColor: const Color(0xFFEFEFF5),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        side: BorderSide.none,
      ),
    );
  }

  // Bitta qayd kartasi
  Widget _buildNoteCard(Note note) {
    return Card(
      color: note.color,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
        leading: Container(
          width: 42,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.sticky_note_2,
            color: Colors.deepOrange.shade400,
          ),
        ),
        title: Text(
          note.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                note.date,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          icon: Icon(
            note.isFavorite
                ? Icons.star
                : Icons.more_vert,
            color: note.isFavorite
                ? Colors.orange
                : Colors.black54,
          ),
          onSelected: (value) {
            if (value == 'favorite') {
              toggleFavorite(note);
            } else if (value == 'archive') {
              toggleArchive(note);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'favorite',
              child: Text(
                note.isFavorite
                    ? 'Sevimlilardan chiqarish'
                    : 'Sevimlilarga qo‘shish',
              ),
            ),
            PopupMenuItem(
              value: 'archive',
              child: Text(
                note.isArchived
                    ? 'Arxivdan chiqarish'
                    : 'Arxivga yuborish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

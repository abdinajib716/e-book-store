import 'package:flutter/material.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Downloads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearDownloadsDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        // TODO: Replace with actual download data
        future: Future.value([
          {
            'title': 'Sheekooyin Soomaaliyeed',
            'author': 'Maxamed Daahir Afrax',
            'size': '2.3 MB',
            'progress': 1.0,
          },
          {
            'title': 'Aqoondarro waa u Nacab Jacayl',
            'author': 'Faarax M.J Cawl',
            'size': '3.1 MB',
            'progress': 0.7,
          },
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement retry
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final downloads = snapshot.data!;
          if (downloads.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.download_done_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No downloads yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/library');
                    },
                    child: const Text('Browse Library'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final download = downloads[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.book_outlined),
                  title: Text(download['title']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(download['author']),
                      const SizedBox(height: 4),
                      if (download['progress'] < 1.0)
                        LinearProgressIndicator(
                          value: download['progress'],
                          backgroundColor: Colors.grey[200],
                        )
                      else
                        Text(
                          download['size'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showDownloadOptions(context, download);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showClearDownloadsDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Downloads'),
        content: const Text(
          'Are you sure you want to delete all downloaded books? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement clear downloads
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDownloadOptions(
    BuildContext context,
    Map<String, dynamic> download,
  ) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete Download'),
              onTap: () {
                // TODO: Implement delete download
                Navigator.pop(context);
              },
            ),
            if (download['progress'] < 1.0)
              ListTile(
                leading: const Icon(Icons.pause),
                title: const Text('Pause Download'),
                onTap: () {
                  // TODO: Implement pause download
                  Navigator.pop(context);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Read Book'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(
                    context,
                    '/library/reader',
                    arguments: {
                      'title': download['title'],
                      'url': 'file://path/to/downloaded/book.pdf', // TODO: Use actual path
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

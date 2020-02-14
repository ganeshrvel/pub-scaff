@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: {{title}}(
      title: Text('Startup Name Generator'),
    ),
    body: _buildSuggestions(),
  );
}

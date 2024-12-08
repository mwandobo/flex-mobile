import 'package:flex_mobile/features/cost/cost-list.dart';
import 'package:flex_mobile/features/indicator/indicator-list.dart';
import 'package:flex_mobile/features/resource/resource-list.dart';
import 'package:flutter/material.dart';

class ProjectCardDetailScreen extends StatefulWidget {
  final dynamic project;
  final String title;

  const ProjectCardDetailScreen({
    Key? key,
    required this.project,
    required this.title,
  }) : super(key: key);

  @override
  _ProjectCardDetailScreenState createState() =>
      _ProjectCardDetailScreenState();
}

class _ProjectCardDetailScreenState extends State<ProjectCardDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedStartDate =
        widget.project['formatted_start_date'] ?? 'Not Available';
    final formattedEndDate =
        widget.project['formatted_end_date'] ?? 'Not Available';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project['name'] ?? "Project Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.title}: ${widget.project['name'] ?? "N/A"}',
                style: Theme.of(context).textTheme.headline6),
            Text('Code: ${widget.project['formatted_code'] ?? "N/A"}'),
            Text('Status: ${widget.project['status'] ?? "N/A"}'),
            Text('Start Date: $formattedStartDate'),
            Text('End Date: $formattedEndDate'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),
            if (widget.title.toLowerCase() == 'activity') ...[
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Indicators'),
                  Tab(text: 'Resources'),
                  Tab(text: 'Costs'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    const IndicatorList(),
                    const ResourceList(),
                    CostList(projectId: widget.project['project_id']),
                  ],
                ),
              ),
            ] else ...[
              Text('Indicators:', style: Theme.of(context).textTheme.headline6),
              const SizedBox(height: 10),
              const Expanded(child: IndicatorList()),
            ],
          ],
        ),
      ),
    );
  }
}

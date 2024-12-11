import 'package:flutter/material.dart';
import 'package:incident_app/domain/entities/ticket.dart';
import 'package:incident_app/domain/providers/ticket_provider.dart';
import 'package:incident_app/presentation/widgets/shared/info_card.dart';
import 'package:provider/provider.dart';
import 'package:incident_app/domain/providers/branch_provider.dart';
import 'package:incident_app/domain/providers/auth_provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
        ticketProvider.getTickets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Tickets'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ticketProvider.isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ticketProvider.tickets.isEmpty 
          ? const Center(child: Text("No hay tickets disponibles"))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Tickets",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InfoCard(
                          value: ticketProvider.tickets.length.toString(),
                          title: "Total Tickets",
                          color: Colors.blueGrey
                        ),
                        InfoCard(
                          value: ticketProvider.itSupportCount.toString(),
                          title: "IT Support",
                          color: Colors.orange
                        ),
                        InfoCard(
                          value: ticketProvider.highPriorityCount.toString(),
                          title: "Alta Prioridad",
                          color: Colors.red
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Últimos tickets registrados",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: ticketProvider.tickets.length,
                        itemBuilder: (context, index) {
                          final ticket = ticketProvider.tickets[index];
                          return Card(
                            child: ListTile(
                              title: Text(ticket.title),
                              subtitle: Text(ticket.description),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(ticket.priority),
                                    backgroundColor: ticket.priority == 'HIGH' 
                                      ? Colors.red[100] 
                                      : Colors.blue[100],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showEditDialog(context, ticket),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _showDeleteConfirmDialog(context, ticket),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTicketDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, Ticket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de eliminar el ticket ${ticket.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
              final success = await ticketProvider.deleteTicket(ticket.id);
              if (success && context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket eliminado exitosamente')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Ticket ticket) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController(text: ticket.title);
    final descriptionController = TextEditingController(text: ticket.description);
    String selectedPriority = ticket.priority;
    String selectedCategory = ticket.category;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Ticket'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ['HIGH', 'MEDIUM', 'LOW'].map((priority) => 
                  DropdownMenuItem(value: priority, child: Text(priority))
                ).toList(),
                onChanged: (value) => selectedPriority = value ?? 'LOW',
                decoration: const InputDecoration(labelText: 'Prioridad'),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ['IT_SUPPORT', 'MAINTENANCE', 'OTHER'].map((category) => 
                  DropdownMenuItem(value: category, child: Text(category))
                ).toList(),
                onChanged: (value) => selectedCategory = value ?? 'OTHER',
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
                final success = await ticketProvider.updateTicket(
                  ticket.id,
                  {
                    'title': titleController.text,
                    'description': descriptionController.text,
                    'priority': selectedPriority,
                    'category': selectedCategory,
                  }
                );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ticket actualizado exitosamente')),
                  );
                }
              }
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedPriority = 'HIGH';
    String selectedCategory = 'IT_SUPPORT';
    String selectedBranch = '';
    final latController = TextEditingController();
    final lngController = TextEditingController();

    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (branchProvider.branches.isEmpty) {
      branchProvider.getBranches();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Crear nuevo ticket'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: latController,
                        decoration: InputDecoration(
                          labelText: 'Latitud',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: lngController,
                        decoration: InputDecoration(
                          labelText: 'Longitud',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedBranch.isEmpty ? null : selectedBranch,
                  decoration: InputDecoration(
                    labelText: 'Sucursal',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  items: branchProvider.branches
                      .map((branch) => DropdownMenuItem(value: branch.id, child: Text(branch.name)))
                      .toList(),
                  onChanged: (value) => selectedBranch = value ?? '',
                  validator: (value) => value == null ? 'Seleccione una sucursal' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  items: ['IT_SUPPORT', 'MAINTENANCE', 'OTHER']
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (value) => selectedCategory = value ?? 'IT_SUPPORT',
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Prioridad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  items: ['HIGH', 'MEDIUM', 'LOW']
                      .map((priority) => DropdownMenuItem(value: priority, child: Text(priority)))
                      .toList(),
                  onChanged: (value) => selectedPriority = value ?? 'HIGH',
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
                
                final success = await ticketProvider.createTicket({
                  'title': titleController.text,
                  'description': descriptionController.text,
                  'branch': selectedBranch,
                  'category': selectedCategory,
                  'priority': selectedPriority,
                  'createdBy': authProvider.user?.id ?? '',
                  'location': {
                    'type': 'Point',
                    'coordinates': [
                      double.parse(lngController.text),
                      double.parse(latController.text)
                    ]
                  }
                });

                if (success && context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ticket creado exitosamente')),
                  );
                }
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
                                  // Action buttons
                                  Row(
                                    children: [
                                      if (status != 'approved')
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => vm.updateStatus(app['id'], 'approved'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Approve'),
                                          ),
                                        ),
                                      if (status != 'approved' && status != 'rejected')
                                        const SizedBox(width: 8),
                                      if (status != 'rejected')
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () => vm.updateStatus(app['id'], 'rejected'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                            ),
                                            child: const Text('Reject'),
                                          ),
                                        ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        onPressed: () => _confirmDelete(context, vm, app['id']),
                                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                                        tooltip: 'Delete',
                                      ),
                                    ],
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
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AdminViewModel vm, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Application'),
        content: const Text('Are you sure you want to remove this application?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              vm.deleteApplication(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

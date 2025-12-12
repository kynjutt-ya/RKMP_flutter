// lib/features/support_safety/cubit/support_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/support/create_ticket_usecase.dart';
import '../../../domain/usecases/support/get_all_tickets_usecase.dart';
import '../../../shared/support_ticket_adapter.dart';
import '../models/support_ticket.dart';

class FAQItem {
  final String id;
  final String question;
  final String answer;
  final String category;

  FAQItem({
    required this.id,
    required this.question,
    required this.answer,
    this.category = 'general',
  });
}

class SupportCubit extends Cubit<SupportState> {
  final CreateTicketUseCase createTicketUseCase;
  final GetAllTicketsUseCase getAllTicketsUseCase;

  SupportCubit({
    required this.createTicketUseCase,
    required this.getAllTicketsUseCase,
  }) : super(const SupportState()) {
    loadFaq();
    loadTickets();
  }

  void setSelectedTicket(SupportTicket? ticket) {
    emit(state.copyWith(selectedTicket: ticket));
  }

  Future<void> createTicket({
    required String userId,
    String? itemId,
    required String category,
    required String message,
    String? imageUrl,
  }) async {
    try {
      print('➕ Создание обращения в поддержку: userId=$userId, category=$category');
      
      // Создаем модель для Clean Architecture
      final ticketModel = SupportTicketAdapter.toModel(
        SupportTicket(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          itemId: itemId,
          category: category,
          message: message,
        ),
      );

      // Сохраняем в БД через use case
      final createdModel = await createTicketUseCase(ticketModel);
      print('✅ Обращение сохранено в БД: id=${createdModel.id}');

      // Конвертируем обратно в SupportTicket для UI
      final ticket = SupportTicketAdapter.toTicket(createdModel);

      // Перезагружаем все обращения из БД
      await loadTickets();

      emit(state.copyWith(selectedTicket: ticket));
    } catch (e) {
      print('❌ Ошибка создания обращения: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> loadTickets({String? userId}) async {
    try {
      print('🔄 Загрузка обращений в поддержку из БД...');
      final ticketsModels = await getAllTicketsUseCase();
      print('✅ Загружено ${ticketsModels.length} обращений');
      
      // Конвертируем в SupportTicket для UI
      final tickets = SupportTicketAdapter.toTicketList(ticketsModels);
      
      emit(state.copyWith(tickets: tickets));
    } catch (e) {
      print('❌ Ошибка загрузки обращений: $e');
      emit(state.copyWith(error: e.toString()));
    }
  }

  void updateTicketStatus(String ticketId, String status) {
    final updatedTickets = state.tickets.map((ticket) {
      if (ticket.id == ticketId) {
        return ticket.copyWith(status: status);
      }
      return ticket;
    }).toList();

    final selectedTicket = state.selectedTicket?.id == ticketId
        ? updatedTickets.firstWhere((t) => t.id == ticketId)
        : state.selectedTicket;

    emit(state.copyWith(
      tickets: updatedTickets,
      selectedTicket: selectedTicket,
    ));
  }

  void loadFaq() {
    // В реальном приложении здесь будет загрузка с сервера
    final faqList = [
      FAQItem(
        id: '1',
        question: 'Как безопасно встретиться с продавцом?',
        answer: 'Выбирайте публичные места, лучше днём. Сообщите друзьям о встрече. Проверяйте вещь перед оплатой.',
        category: 'safety',
      ),
      FAQItem(
        id: '2',
        question: 'Что делать, если товар не соответствует описанию?',
        answer: 'Свяжитесь с продавцом через чат. Если не удалось решить вопрос, создайте тикет поддержки.',
        category: 'general',
      ),
      FAQItem(
        id: '3',
        question: 'Как сообщить о мошенничестве?',
        answer: 'Перейдите в раздел "Поддержка" → "Сообщить о проблеме" и выберите категорию "Мошенничество".',
        category: 'safety',
      ),
      FAQItem(
        id: '4',
        question: 'Можно ли обменять вещи?',
        answer: 'Да, если продавец указал "Возможен обмен" в объявлении. Обсудите детали в чате.',
        category: 'general',
      ),
      FAQItem(
        id: '5',
        question: 'Как утилизировать вещь, если её не удалось продать?',
        answer: 'Используйте раздел "Эко-гид" → "Карта пунктов приёма" для поиска ближайших пунктов утилизации.',
        category: 'eco',
      ),
    ];
    emit(state.copyWith(faqList: faqList));
  }
}

class SupportState {
  final List<SupportTicket> tickets;
  final SupportTicket? selectedTicket;
  final List<FAQItem> faqList;
  final String? error;

  const SupportState({
    this.tickets = const [],
    this.selectedTicket,
    this.faqList = const [],
    this.error,
  });

  SupportState copyWith({
    List<SupportTicket>? tickets,
    SupportTicket? selectedTicket,
    List<FAQItem>? faqList,
    String? error,
  }) {
    return SupportState(
      tickets: tickets ?? this.tickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      faqList: faqList ?? this.faqList,
      error: error,
    );
  }
}

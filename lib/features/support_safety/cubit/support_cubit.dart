// lib/features/support_safety/cubit/support_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
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
  SupportCubit() : super(const SupportState()) {
    loadFaq();
    loadTickets();
  }

  void setSelectedTicket(SupportTicket? ticket) {
    emit(state.copyWith(selectedTicket: ticket));
  }

  void createTicket({
    required String userId,
    String? itemId,
    required String category,
    required String message,
    String? imageUrl,
  }) {
    final ticket = SupportTicket(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      itemId: itemId,
      category: category,
      message: message,
    );

    final newTickets = [...state.tickets, ticket];
    emit(state.copyWith(tickets: newTickets, selectedTicket: ticket));
  }

  void loadTickets({String? userId}) {
    // В реальном приложении здесь будет загрузка с сервера
    // Пока используем текущие тикеты из состояния
    emit(state);
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

  const SupportState({
    this.tickets = const [],
    this.selectedTicket,
    this.faqList = const [],
  });

  SupportState copyWith({
    List<SupportTicket>? tickets,
    SupportTicket? selectedTicket,
    List<FAQItem>? faqList,
  }) {
    return SupportState(
      tickets: tickets ?? this.tickets,
      selectedTicket: selectedTicket ?? this.selectedTicket,
      faqList: faqList ?? this.faqList,
    );
  }
}

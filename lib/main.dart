import 'package:flutter/material.dart'; // Flutter 머티리얼 디자인 패키지 가져오기

void main() {
  runApp(const MyApp()); // 앱 실행 시작점
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // 생성자 정의

  @override
  Widget build(BuildContext context) {
    // 앱의 기본 구조 정의
    return MaterialApp(
      title: 'Flutter Todo App', // 앱 제목
      theme: ThemeData(
        primarySwatch: Colors.blue, // 앱의 주요 색상 테마
        useMaterial3: true, // Material 3 디자인 사용
      ),
      home: const TodoScreen(), // 시작 화면 설정
    );
  }
}

class Task {
  String title; // 할 일 제목
  bool isCompleted; // 완료 여부 상태

  // Task 클래스 생성자 - 기본적으로 완료되지 않은 상태로 초기화
  Task({required this.title, this.isCompleted = false});
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key); // 생성자 정의

  @override
  State<TodoScreen> createState() => _TodoScreenState(); // 상태 클래스 생성
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Task> _tasks = []; // 할 일 목록을 저장하는 리스트
  final TextEditingController _textController =
      TextEditingController(); // 텍스트 입력 컨트롤러

  // 새 할 일 추가 함수
  void _addTask(String title) {
    if (title.trim().isNotEmpty) {
      // 입력된 텍스트가 비어있지 않은지 확인
      setState(() {
        _tasks.add(Task(title: title)); // 새 할 일 추가
      });
      _textController.clear(); // 입력 필드 초기화
    }
  }

  // 할 일 완료/미완료 토글 함수
  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted; // 완료 상태 반전
    });
  }

  // 할 일 삭제 함수
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index); // 지정된 인덱스의 할 일 삭제
    });
  }

  @override
  Widget build(BuildContext context) {
    // 화면 UI 구성
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'), // 앱바 제목
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer, // 앱바 배경색
      ),
      body: Column(
        children: [
          // 새 할 일 입력 영역
          Padding(
            padding: const EdgeInsets.all(16.0), // 모든 방향으로 16픽셀 패딩
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController, // 텍스트 컨트롤러 연결
                    decoration: const InputDecoration(
                      hintText: 'Add a new task', // 힌트 텍스트
                      border: OutlineInputBorder(), // 테두리 스타일
                    ),
                    onSubmitted: (value) => _addTask(value), // 엔터 키 입력 시 할 일 추가
                  ),
                ),
                const SizedBox(width: 8), // 간격 추가
                ElevatedButton(
                  onPressed:
                      () => _addTask(_textController.text), // 버튼 클릭 시 할 일 추가
                  child: const Text('Add'), // 버튼 텍스트
                ),
              ],
            ),
          ),
          // 할 일 목록 표시 영역
          Expanded(
            child:
                _tasks.isEmpty
                    ? const Center(
                      child: Text('No tasks yet. Add one!'),
                    ) // 할 일이 없을 때 메시지
                    : ListView.builder(
                      // 할 일 목록 리스트뷰
                      itemCount: _tasks.length, // 아이템 개수
                      itemBuilder: (context, index) {
                        final task = _tasks[index]; // 현재 할 일 가져오기
                        return Dismissible(
                          // 스와이프로 삭제 가능한 위젯
                          key: Key(task.title + index.toString()), // 고유 키 값
                          background: Container(
                            // 스와이프 시 보이는 배경
                            color: Colors.red, // 배경색
                            alignment: Alignment.centerRight, // 오른쪽 정렬
                            padding: const EdgeInsets.only(
                              right: 16.0,
                            ), // 오른쪽 패딩
                            child: const Icon(
                              Icons.delete, // 삭제 아이콘
                              color: Colors.white, // 아이콘 색상
                            ),
                          ),
                          direction:
                              DismissDirection.endToStart, // 오른쪽에서 왼쪽으로 스와이프
                          onDismissed:
                              (direction) => _deleteTask(index), // 스와이프 완료 시 삭제
                          child: ListTile(
                            // 할 일 항목 타일
                            leading: Checkbox(
                              // 체크박스
                              value: task.isCompleted, // 완료 상태 반영
                              onChanged:
                                  (bool? value) =>
                                      _toggleTask(index), // 체크박스 상태 변경 시 호출
                            ),
                            title: Text(
                              task.title, // 할 일 제목
                              style: TextStyle(
                                decoration:
                                    task.isCompleted
                                        ? TextDecoration
                                            .lineThrough // 완료된 할 일은 취소선 표시
                                        : null,
                                color:
                                    task.isCompleted
                                        ? Colors
                                            .grey // 완료된 할 일은 회색으로 표시
                                        : Colors.black,
                              ),
                            ),
                            trailing: IconButton(
                              // 삭제 버튼
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteTask(index), // 버튼 클릭 시 삭제
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose(); // 메모리 누수 방지를 위한 컨트롤러 해제
    super.dispose(); // 부모 클래스의 dispose 호출
  }
}

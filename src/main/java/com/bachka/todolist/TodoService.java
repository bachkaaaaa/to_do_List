package com.bachka.todolist;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class TodoService {

    private TodoRepository todoRepository;

    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
    }

    public void addTodo(Todo todo) {
        todoRepository.save(todo);
    }

    public void deleteTodoById(Long id) {
        todoRepository.deleteById(id);
    }
}
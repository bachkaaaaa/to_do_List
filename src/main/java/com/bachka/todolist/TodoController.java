package com.bachka.todolist;

import lombok.AllArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
@AllArgsConstructor
public class TodoController {

    private TodoService todoService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("todos", todoService.getAllTodos());
        model.addAttribute("newTodo", new Todo());
        return "index";
    }

    @PostMapping("/addTodo")
    public String addTodo(@ModelAttribute("newTodo") Todo todo) {
        todoService.addTodo(todo);
        return "redirect:/";
    }

    @GetMapping("/deleteTodo/{id}")
    public String deleteTodo(@PathVariable Long id) {
        todoService.deleteTodoById(id);
        return "redirect:/";
    }
}

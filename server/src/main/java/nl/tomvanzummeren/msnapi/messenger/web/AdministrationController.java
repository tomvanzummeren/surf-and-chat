package nl.tomvanzummeren.msnapi.messenger.web;

import nl.tomvanzummeren.msnapi.messenger.service.ActiveSession;
import nl.tomvanzummeren.msnapi.messenger.service.MessengerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.RedirectView;

import java.util.List;

/**
 * @author Tom van Zummeren
 */
@Controller
@RequestMapping("admin")
public class AdministrationController {

    private MessengerService messengerService;

    @Autowired
    public AdministrationController(MessengerService messengerService) {
        this.messengerService = messengerService;
    }

    @RequestMapping("")
    public ModelAndView listActiveSessions() {
        List<ActiveSession> activeSessions = messengerService.listActiveSessions();
        return new ModelAndView("list-active-sessions").addObject("activeSessions", activeSessions);
    }

    @RequestMapping("disconnect")
    public View disconnect(@RequestParam String sessionId) {
        messengerService.destroyUserSession(sessionId);
        return new RedirectView("");
    }
}
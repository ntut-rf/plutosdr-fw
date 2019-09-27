#ifndef INCLUDED_GR_LOGGER_H
#define INCLUDED_GR_LOGGER_H

#define GR_DEBUG(name, msg) printf("[%s] %s", name, msg)
#define GR_INFO     GR_DEBUG
#define GR_NOTICE   GR_DEBUG
#define GR_WARN     GR_DEBUG
#define GR_ERROR    GR_DEBUG
#define GR_CRIT     GR_DEBUG
#define GR_ALERT    GR_DEBUG
#define GR_FATAL    GR_DEBUG
#define GR_EMERG    GR_DEBUG

#define GR_LOG_DEBUG(logger, msg)   printf("%s", msg)
#define GR_LOG_INFO     GR_LOG_DEBUG
#define GR_LOG_NOTICE   GR_LOG_DEBUG                                                
#define GR_LOG_WARN     GR_LOG_DEBUG
#define GR_LOG_ERROR    GR_LOG_DEBUG
#define GR_LOG_CRIT     GR_LOG_DEBUG
#define GR_LOG_ALERT    GR_LOG_DEBUG
#define GR_LOG_FATAL    GR_LOG_DEBUG
#define GR_LOG_EMERG    GR_LOG_DEBUG

#endif /* INCLUDED_GR_LOGGER_H */

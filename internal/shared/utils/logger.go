package utils

import (
	"log"
	"os"
)

// Logger はログ機能を提供します
type Logger struct {
	*log.Logger
}

// NewLogger は新しいLoggerを作成します
func NewLogger() *Logger {
	return &Logger{
		Logger: log.New(os.Stdout, "[API] ", log.LstdFlags|log.Lshortfile),
	}
}

// Info は情報ログを出力します
func (l *Logger) Info(format string, v ...interface{}) {
	l.Printf("[INFO] "+format, v...)
}

// Error はエラーログを出力します
func (l *Logger) Error(format string, v ...interface{}) {
	l.Printf("[ERROR] "+format, v...)
}

// Debug はデバッグログを出力します
func (l *Logger) Debug(format string, v ...interface{}) {
	l.Printf("[DEBUG] "+format, v...)
}

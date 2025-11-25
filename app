import { useEffect, useState   } from "react";
import axios from "axios";


function App() {
const [students, setStudents] = useState([]);
const [loading, setLoading] = useState(false);
const [name, setName] = useState("");
const [age, setAge] = useState("");

useEffect(() => {
  fetchStudents();
}, [])

function fetchStudents() {
  setLoading(true);
  axios.get('/api/students')
    .then(res => setStudents(res.data))
    .then(() => setLoading(false));
}

function addStudent(e) {
 e.preventDefault();
  const trimmed = name.trim();
  if (!trimmed) return;
  
  const newStudent = {
    name: trimmed, 
    age: age === '' ? null : Number(age),
  };

  axios.post('/api/students', newStudent)
    .then(res => {
      setStudents(prev => [...prev, res.data]);
      setName('');
      setAge('');
    })
    .catch(err => console.error(err));
}
function deleteStudent(id) {
  axios.delete(`/api/students/${id}`)
    .then(() => {
      setStudents(students.filter(s => s.id !== id));
    })
    .catch(err => console.error(err));
}  return (
  <div className="app-container">
    <h1>Student List</h1>

    <form onSubmit={addStudent}>
      <input 
        type="text" 
        placeholder="Name"
        value={name}
        onChange={e => setName(e.target.value)}
      />

      <input 
        type="number" 
        placeholder="Age"
        value={age}
        onChange={e => setAge(e.target.value)}
        min="0"
      />
      <button type="submit" disabled={loading}>
        Add Student</button>
    </form>


    {loading ? (
      <p>Loading...</p>
    ) : (
      <div>
        {students.length === 0 ? (
          <p>No students available.</p>
        ) : (
          students.map(student => (
            <div key={student.id} className="student-card">
              <h2>{student.name}</h2>
              <h3>Age : {student.age}</h3>
              <button onClick={() => deleteStudent(student.id)}>Delete</button>
            </div>
          ))
        )}
      </div>
    )}
   </div>

  );

}

export default App;
